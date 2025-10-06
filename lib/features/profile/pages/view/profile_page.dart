import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fooda_best/core/dependencies/dependency_init.dart';
import 'package:fooda_best/core/utilities/configs/app_typography.dart';
import 'package:fooda_best/core/utilities/configs/colors.dart';
import 'package:fooda_best/core/utilities/routes_navigator/navigator.dart';
import 'package:fooda_best/core/widgets/base_flexiable_image.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:fooda_best/features/authentication/pages/view/phone_auth_page.dart';
import 'package:fooda_best/features/profile/pages/view/profile_settings.dart';
import 'package:fooda_best/gen/assets.gen.dart';
import 'package:fooda_best/translations/locale_keys.g.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthenticationCubit _authenticationCubit = getIt<AuthenticationCubit>();
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
                child: FlexibleImage(
                  source: Assets.images.back,
                  width: 16.w,
                  height: 16.h,
                  fit: BoxFit.contain,
                  color: AllColors.black,
                ),
              ),
            ),
          ],
        ),

        title: Text(
          LocaleKeys.profile.tr(),
          style: tb20.copyWith(
            color: AllColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<AuthenticationCubit, AuthenticationState>(
        bloc: _authenticationCubit,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,

                  decoration: BoxDecoration(color: AllColors.white),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: AllColors.grayLight.withValues(
                          alpha: 0.4,
                        ),
                        radius: 40.r,
                        child: state.user?.imageUrl != null
                            ? FlexibleImage(
                                source: state.user?.imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Text(
                                state.user?.displayName
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    'Fooda Best',
                                style: tb30,
                              ),
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        state.user?.displayName ??
                            (state.user?.firstName != null &&
                                    state.user?.lastName != null
                                ? '${state.user!.firstName} ${state.user!.lastName}'
                                : LocaleKeys.user.tr()),
                        style: tr16,
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10.h,
                  children: [
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: LocaleKeys.profileSettings.tr(),
                      onTap: () {
                        _navigateToProfileSettings(context);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.favorite,
                      title: LocaleKeys.favourite.tr(),
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.history,
                      title: LocaleKeys.history.tr(),
                      onTap: () {},
                    ),
                    _buildMenuItemWithToggle(
                      icon: Icons.dark_mode,
                      title: LocaleKeys.darkMode.tr(),
                      isEnabled: false,
                      onToggle: (value) {},
                    ),
                    _buildMenuItem(
                      icon: Icons.language,
                      title: LocaleKeys.selectLanguage.tr(),
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.business,
                      title: LocaleKeys.aboutUs.tr(),
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.phone,
                      title: LocaleKeys.contactUs.tr(),
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.lock,
                      title: LocaleKeys.policyAndPrivacy.tr(),
                      onTap: () {},
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                Container(
                  color: AllColors.white,
                  child: _buildMenuItem(
                    icon: Icons.logout,
                    title: LocaleKeys.logOut.tr(),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                    isDestructive: true,
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AllColors.grayLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AllColors.red : AllColors.black,
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: tm16.copyWith(
                  color: isDestructive ? AllColors.red : AllColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AllColors.grey, size: 16.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemWithToggle({
    required IconData icon,
    required String title,
    required bool isEnabled,
    required ValueChanged<bool> onToggle,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AllColors.grayLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border(
          bottom: BorderSide(
            color: AllColors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AllColors.black, size: 24.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: tm16.copyWith(
                color: AllColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeThumbColor: AllColors.blue,
          ),
        ],
      ),
    );
  }

  void _navigateToProfileSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfileSettingsPage(user: _authenticationCubit.state.user!),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LocaleKeys.logOut.tr(),
            style: tb16.copyWith(
              color: AllColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            LocaleKeys.areYouSureWantToLogOut.tr(),
            style: tm14.copyWith(color: AllColors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                LocaleKeys.cancel.tr(),
                style: tm14.copyWith(color: AllColors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthenticationCubit>().signOut();
                popAllAndPushPage(context, const PhoneAuthPage());
              },
              child: Text(
                LocaleKeys.logOut.tr(),
                style: tm14.copyWith(
                  color: AllColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
