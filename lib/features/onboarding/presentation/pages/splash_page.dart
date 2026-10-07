import 'package:kastelli/core/theme/app_colors.dart';
import 'dart:async';

import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/features/auth/presentation/pages/sign_in_page.dart';
import 'package:kastelli/features/onboarding/presentation/pages/onboarding_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/core/services/app_preferences.dart';
import 'package:kastelli/features/home/presentation/pages/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), () {
      navigateToNextScreen();
    });
  }

  void navigateToNextScreen() {
    if (!mounted) return;

    final prefs = sl<AppPreferences>();
    final token = prefs.getToken();

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: MainPage.routeName),
          builder: (context) => const MainPage(),
        ),
      );
    } else if (prefs.isOnboardingCompleted()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 200.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/img/logo@2x.png",
                        width: 101.w,
                        height: 97.h,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      AppStrings.welcome,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
