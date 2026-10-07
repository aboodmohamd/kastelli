import 'package:kastelli/core/theme/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/core/services/app_preferences.dart';

import 'package:kastelli/features/auth/presentation/pages/sign_in_page.dart';
import 'package:kastelli/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  void initState() {
    super.initState();
    sl<AppPreferences>().setOnboardingCompleted(true);
  }

  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<Map<String, dynamic>> bannerData = [
    {
      "title": AppStrings.onboardingTitle1,
      "subtitle": AppStrings.onboardingSubtitle1,
    },
    {
      "title": AppStrings.onboardingTitle2,
      "subtitle": AppStrings.onboardingSubtitle2,
    },
    {
      "title": AppStrings.onboardingTitle3,
      "subtitle": AppStrings.onboardingSubtitle3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<OnboardingProvider>().currentIndex;

    return GestureDetector(
      onTap: () => _hideKeyboard(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 70.h),
                    child: CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: 202.h,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          context.read<OnboardingProvider>().changeIndex(index);
                        },
                      ),
                      items: bannerData.map((data) {
                        return SizedBox(
                          width: 1.sw,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.w, bottom: 50.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['title'],
                                  style: const TextStyle(
                                    fontSize: 37,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textDark,
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Text(
                                  data['subtitle'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textSubtitle,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 260.h,
                  ),
                  Positioned(
                    bottom: 15.h,
                    left: 20.w,
                    child: Row(
                      children: bannerData.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () =>
                              _carouselController.animateToPage(entry.key),
                          child: Container(
                            width: 8.w,
                            height: 8.h,
                            margin: EdgeInsets.only(right: 6.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == entry.key
                                  ? AppColors.primary
                                  : AppColors.accent,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.only(bottom: 30.h, left: 16.w, right: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(AppColors.black),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 112.5.w,
                            vertical: 12.h,
                          ),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ),
                      child: Text(
                        AppStrings.getStarted,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 22.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
