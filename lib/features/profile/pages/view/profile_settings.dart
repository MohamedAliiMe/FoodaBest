import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/functions/app_alert_dialog.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/utilities/routes_navigator/navigator.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/core/widgets/custom_continue_button.dart';
import 'package:fooda_best/core/widgets/custom_normal_field.dart';
import 'package:fooda_best/features/authentication/data/models/user_model/user_model.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:fooda_best/gen/assets.gen.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

class ProfileSettingsPage extends StatefulWidget {
  final UserModel user;

  const ProfileSettingsPage({super.key, required this.user});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.displayName ?? '';
    _phoneController.text = widget.user.phoneNumber ?? '';
    _emailController.text = widget.user.email ?? '';
    _birthDateController.text = widget.user.dateOfBirth != null
        ? widget.user.dateOfBirth!.toIso8601String().split('T')[0]
        : '';
    _genderController.text = widget.user.gender ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AllColors.white,
        elevation: 0,
        leading: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: 40.w,
                height: 40.h,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: BoxDecoration(
                  color: AllColors.grayLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: GestureDetector(
                  onTap: () => popScreen(context),
                  child: FlexibleImage(
                    source: Assets.images.back,
                    width: 16.w,
                    height: 16.h,
                    fit: BoxFit.contain,
                    color: AllColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          LocaleKeys.profileSettingsTitle.tr(),
          style: tb20.copyWith(
            color: AllColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if (state.isLoading == false && state.errorMessage == null) {
            AppAlertDialog.showSuccessBar(
              message: LocaleKeys.profileUpdatedSuccessfully.tr(),
            );
            popScreen(context);
          } else if (state.errorMessage != null) {
            AppAlertDialog.showErrorBarSafe(errorMessage: state.errorMessage!);
          }
        },
        child: BlocBuilder<AuthenticationCubit, AuthenticationState>(
          builder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.user != null) {
                _nameController.text = state.user!.displayName ?? '';
                _phoneController.text = state.user!.phoneNumber ?? '';
                _emailController.text = state.user!.email ?? '';
                _birthDateController.text = state.user!.dateOfBirth != null
                    ? state.user!.dateOfBirth!.toIso8601String().split('T')[0]
                    : '';
                _genderController.text = state.user!.gender ?? '';
              }
            });

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(40.w),
                          decoration: BoxDecoration(color: AllColors.white),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: AllColors.grayLight.withValues(
                                  alpha: 0.4,
                                ),
                                radius: 60.r,
                                child:
                                    state.user?.imageUrl != null &&
                                        state.user!.imageUrl!.isNotEmpty
                                    ? FlexibleImage(
                                        source: state.user!.imageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : Text(
                                        state.user?.displayName
                                                ?.substring(0, 1)
                                                .toUpperCase() ??
                                            'U',
                                        style: tb30.copyWith(
                                          color: AllColors.blue,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),

                              SizedBox(height: 20.h),

                              Text(
                                state.user?.displayName ??
                                    (state.user?.firstName != null &&
                                            state.user?.lastName != null
                                        ? '${state.user!.firstName} ${state.user!.lastName}'
                                        : LocaleKeys.user.tr()),
                                style: tb24.copyWith(
                                  color: AllColors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          color: AllColors.white,
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              _buildFormField(
                                label: LocaleKeys.name.tr(),
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                              ),
                              SizedBox(height: 16.h),
                              _buildFormField(
                                label: LocaleKeys.phoneNumber.tr(),
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                              SizedBox(height: 16.h),
                              _buildFormField(
                                label: LocaleKeys.email.tr(),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 16.h),
                              _buildFormField(
                                label: LocaleKeys.birthDate.tr(),
                                controller: _birthDateController,
                                keyboardType: TextInputType.datetime,
                              ),
                              SizedBox(height: 16.h),
                              _buildFormField(
                                label: LocaleKeys.gender.tr(),
                                controller: _genderController,
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child:
                        BlocBuilder<AuthenticationCubit, AuthenticationState>(
                          builder: (context, state) {
                            return CustomContinueButton(
                              text: LocaleKeys.saveChanges.tr(),
                              onPressed: () {
                                _saveProfile();
                              },
                              isEnabled: true,
                              isLoading: state.isLoading,
                            );
                          },
                        ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return CustomNormalField(
      label: label,
      controller: controller,
      useModernLabelStyle: false,
    );
  }

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.nameIsRequired.tr()),
          backgroundColor: AllColors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.emailIsRequired.tr()),
          backgroundColor: AllColors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    DateTime? birthDate;
    if (_birthDateController.text.trim().isNotEmpty) {
      try {
        final dateString = _birthDateController.text.trim();
        birthDate = DateTime.parse(dateString);

        if (birthDate.isAfter(DateTime.now())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.birthDateCannotBeInFuture.tr()),
              backgroundColor: AllColors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.invalidBirthDateFormat.tr()),
            backgroundColor: AllColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    }

    context.read<AuthenticationCubit>().updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _genderController.text.trim().isNotEmpty
          ? _genderController.text.trim()
          : null,
      dateOfBirth: birthDate,
    );
  }
}
