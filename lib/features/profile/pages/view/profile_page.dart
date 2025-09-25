import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fooda_best/core/utilities/routes_navigator/navigator.dart';
import 'package:fooda_best/features/authentication/logic/authentication_cubit.dart';
import 'package:fooda_best/features/authentication/pages/view/phone_auth_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoggingOut = false;

  void _logout() async {
    setState(() {
      _isLoggingOut = true;
    });
    await context.read<AuthenticationCubit>().signOut();
    setState(() {
      _isLoggingOut = false;
    });
    // After logout, navigate to OTP screen or login screen
    if (mounted) {
      popAllAndPushPage(context, const PhoneAuthPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _isLoggingOut ? null : _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: _isLoggingOut
            ? const CircularProgressIndicator()
            : const Text('Profile Page'),
      ),
    );
  }
}
