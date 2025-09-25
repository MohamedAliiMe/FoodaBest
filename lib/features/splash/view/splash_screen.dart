import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fooda_best/core/app_authentication_state/app_authentication_state.dart';
import 'package:fooda_best/core/dependencies/dependency_init.dart';
import 'package:fooda_best/core/utilities/app_data_storage.dart';
import 'package:fooda_best/features/authentication/pages/view/phone_auth_page.dart';
import 'package:fooda_best/features/profile/pages/view/profile_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoFromBottomCenter;
  late Animation<Offset> _logoToLeft;
  late Animation<double> _logoScale;

  late List<AnimationController> _letterControllers;
  final String _textLetters = "FOODABEST";

  late Animation<double> _progressOpacity;

  int _currentFocusIndex = 0;
  Timer? _focusTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
    _checkAuthState();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeIn),
    );

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.1, curve: Curves.easeIn),
      ),
    );

    _logoFromBottomCenter =
        Tween<Offset>(begin: const Offset(0, 3.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
          ),
        );

    _logoToLeft = Tween<Offset>(begin: Offset.zero, end: const Offset(-0.6, 0))
        .animate(
          CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.6, 1.0, curve: Curves.fastOutSlowIn),
          ),
        );

    _logoScale = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _letterControllers = List.generate(
      _textLetters.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
  }

  void _startSequence() async {
    _progressController.forward();
    _startFocusAnimation();

    await Future.delayed(const Duration(milliseconds: 500));

    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 1200));

    _animateLetters();
  }

  void _animateLetters() async {
    for (int i = 0; i < _letterControllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        _letterControllers[i].forward();
      }
    }
  }

  void _startFocusAnimation() {
    _focusTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _currentFocusIndex = (_currentFocusIndex + 1) % 5;
        });
      }
    });
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 8));

    final dataStorage = getIt<DataStorage>();
    final authState = await dataStorage.getData('appAuthenticationState');

    if (mounted) {
      if (authState == AppAuthenticationStateEnum.customerState.name) {
        _changeScreen(AppAuthenticationStateEnum.customerState);
      } else {
        _changeScreen(AppAuthenticationStateEnum.unauthorizedState);
      }
    }
  }

  void _changeScreen(AppAuthenticationStateEnum stateEnum) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            stateEnum == AppAuthenticationStateEnum.unauthorizedState
            ? const PhoneAuthPage()
            : const ProfilePage(),
      ),
    );
  }

  String _getProgressImagePath() {
    switch (_currentFocusIndex) {
      case 0:
        return 'assets/images/Property-Default.svg';
      case 1:
        return 'assets/images/Property-Variant2.svg';
      case 2:
        return 'assets/images/Property-Variant3.svg';
      case 3:
        return 'assets/images/Property-Variant4.svg';
      case 4:
        return 'assets/images/Property-Variant5.svg';
      default:
        return 'assets/images/Property-Default.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 100.h,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return Opacity(
                  opacity: _progressOpacity.value,
                  child: Center(
                    child: SvgPicture.asset(_getProgressImagePath()),
                  ),
                );
              },
            ),
          ),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(
                        (_logoFromBottomCenter.value.dx +
                                _logoToLeft.value.dx) *
                            0.w,
                        (_logoFromBottomCenter.value.dy +
                                _logoToLeft.value.dy) *
                            50.h,
                      ),
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _logoOpacity.value,
                          child: SvgPicture.asset(
                            'assets/images/Company logo.svg',
                          ),
                        ),
                      ),
                    );
                  },
                ),

                AnimatedBuilder(
                  animation: _letterControllers.isNotEmpty
                      ? _letterControllers[0]
                      : _textController,
                  builder: (context, child) {
                    int visibleLetters = 0;
                    for (int i = 0; i < _letterControllers.length; i++) {
                      if (_letterControllers[i].value > 0.2) visibleLetters++;
                    }

                    return ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: visibleLetters / _textLetters.length,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: visibleLetters < _textLetters.length
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 2,
                                      offset: const Offset(1, 1),
                                      spreadRadius: 0,
                                    ),
                                  ]
                                : [],
                          ),
                          child: SvgPicture.asset(
                            'assets/images/FoodaBest.svg',
                            height: 35.h,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    for (var controller in _letterControllers) {
      controller.dispose();
    }
    _focusTimer?.cancel();
    super.dispose();
  }
}
