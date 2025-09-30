import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/dependencies/dependency_init.dart';
import 'package:fooda_best/core/functions/app_alert_dialog.dart';
import 'package:fooda_best/core/utilities/app_validator.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/utilities/routes_navigator/navigator.dart';
import 'package:fooda_best/core/widgets/custom_continue_button.dart';
import 'package:fooda_best/core/widgets/custom_date_picker.dart';
import 'package:fooda_best/core/widgets/custom_text_field.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:fooda_best/features/product_analysis/pages/view/product_analysis_page.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final AuthenticationCubit _authenticationCubit = getIt<AuthenticationCubit>();
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  int _currentStep = 0;

  List<String> get _genderOptions => [
    LocaleKeys.man.tr(),
    LocaleKeys.woman.tr(),
    LocaleKeys.preferNotToSay.tr(),
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_updateFormValidation);
    _lastNameController.addListener(_updateFormValidation);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_updateFormValidation);
    _lastNameController.removeListener(_updateFormValidation);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _authenticationCubit.close();
    super.dispose();
  }

  void _updateFormValidation() {
    setState(() {});
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else if (_currentStep == 1) {
      setState(() {
        _currentStep = 2;
      });
    } else {
      _completeProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _completeProfile() {
    if (_formKey.currentState!.validate()) {
      _authenticationCubit.updateProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        gender: _selectedGender,
        dateOfBirth: _selectedDateOfBirth,
      );
    }
  }

  void _onDateChanged(DateTime date) {
    setState(() {
      _selectedDateOfBirth = date;
      _updateFormValidation();
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AllColors.white,
      centerTitle: false,
      elevation: 0,
      leading: _currentStep > 0
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: AllColors.black),
              onPressed: _previousStep,
            )
          : null,
      title: _currentStep == 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _nextStep();
                    setState(() {
                      _selectedGender = LocaleKeys.preferNotToSay.tr();
                      _updateFormValidation();
                    });
                  },
                  child: Text(
                    LocaleKeys.skipText.tr(),
                    textAlign: TextAlign.end,
                    style: tr18.copyWith(color: AllColors.blue),
                  ),
                ),
              ],
            )
          : null,
    );
  }

  BlocListener<AuthenticationCubit, AuthenticationState> _buildBody() {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      bloc: _authenticationCubit,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppAlertDialog.showErrorBar(errorMessage: state.errorMessage);
        }
        if (state.user != null &&
            !state.isLoading &&
            state.user!.firstName != null &&
            state.user!.firstName!.isNotEmpty &&
            state.user!.lastName != null &&
            state.user!.lastName!.isNotEmpty) {
          popAllAndPushPage(context, const ProductAnalysisPage());
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(key: _formKey, child: _buildCurrentStep()),
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Container _buildBottomSection() {
    return Container(
      decoration: BoxDecoration(
        color: AllColors.white,
        boxShadow: [
          BoxShadow(
            color: AllColors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, -2.r),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildProgressBar(),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h),
            child: _buildContinueButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 4.h,
      width: double.infinity,
      decoration: BoxDecoration(color: AllColors.grayLight),
      child: Row(
        children: [
          Expanded(
            flex: _currentStep + 1,
            child: Container(
              decoration: BoxDecoration(
                color: AllColors.blue,
                borderRadius: BorderRadius.only(
                  topRight: _currentStep == 2
                      ? Radius.circular(2.r)
                      : Radius.zero,
                  bottomRight: _currentStep == 2
                      ? Radius.circular(2.r)
                      : Radius.zero,
                ),
              ),
            ),
          ),
          Expanded(flex: 3 - (_currentStep + 1), child: Container()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildNameStep();
      case 1:
        return _buildGenderStep();
      case 2:
        return _buildDateOfBirthStep();
      default:
        return _buildNameStep();
    }
  }

  Column _buildNameStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle(LocaleKeys.letsGetToKnowYou.tr()),
        SizedBox(height: 40.h),
        _buildNameFields(),
      ],
    );
  }

  Text _buildStepTitle(String title) {
    return Text(title, style: tb24);
  }

  Column _buildNameFields() {
    return Column(
      children: [
        CustomTextField(
          label: LocaleKeys.firstName.tr(),
          hint: LocaleKeys.enterFirstName.tr(),
          controller: _firstNameController,
          validator: (value) => AppValidator.validatorName(value, context),
          onChanged: (value) => _updateFormValidation(),
          useModernLabelStyle: false,
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          label: LocaleKeys.lastName.tr(),
          hint: LocaleKeys.enterLastName.tr(),
          controller: _lastNameController,
          validator: (value) => AppValidator.validatorName(value, context),
          onChanged: (value) => _updateFormValidation(),
          useModernLabelStyle: false,
          keyboardType: TextInputType.name,
        ),
      ],
    );
  }

  Column _buildGenderStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle(LocaleKeys.whatIsYourGender.tr()),
        SizedBox(height: 40.h),
        _buildGenderOptions(),
      ],
    );
  }

  Column _buildGenderOptions() {
    return Column(
      children: List.generate(_genderOptions.length, (index) {
        final gender = _genderOptions[index];
        return _buildGenderOption(gender);
      }),
    );
  }

  Widget _buildGenderOption(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
          _updateFormValidation();
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AllColors.white,
          border: Border.all(
            color: isSelected ? AllColors.green : AllColors.transparent,
            width: isSelected ? 2.w : 0.w,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(
              _getGenderIcon(gender),
              color: isSelected ? AllColors.green : AllColors.black,
              size: 24.sp,
            ),
            SizedBox(width: 5.w),
            Text(
              gender,
              style: tr16.copyWith(
                color: isSelected ? AllColors.green : AllColors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildDateOfBirthStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle(LocaleKeys.enterYourDateOfBirth.tr()),
        SizedBox(height: 40.h),
        _buildDatePicker(),
      ],
    );
  }

  CustomDatePicker _buildDatePicker() {
    return CustomDatePicker(
      initialDate:
          _selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      onDateChanged: _onDateChanged,
    );
  }

  BlocBuilder<AuthenticationCubit, AuthenticationState> _buildContinueButton() {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      bloc: _authenticationCubit,
      builder: (context, state) {
        final buttonText = _getButtonText();
        final canProceed = _canProceed();

        return CustomContinueButton(
          text: buttonText,
          onPressed: canProceed ? _nextStep : null,
          isLoading: state.isLoading,
          isEnabled: canProceed && !state.isLoading,
        );
      },
    );
  }

  String _getButtonText() {
    switch (_currentStep) {
      case 0:
      case 1:
        return LocaleKeys.continueText.tr();
      case 2:
        return LocaleKeys.letsStart.tr();
      default:
        return LocaleKeys.continueText.tr();
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty;
      case 1:
        return _selectedGender != null;
      case 2:
        return _selectedDateOfBirth != null;
      default:
        return false;
    }
  }

  IconData _getGenderIcon(String gender) {
    if (gender == LocaleKeys.man.tr()) {
      return Icons.male;
    } else if (gender == LocaleKeys.woman.tr()) {
      return Icons.female;
    } else {
      return Icons.visibility_off;
    }
  }
}
