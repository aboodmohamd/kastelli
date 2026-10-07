import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/features/auth/presentation/pages/sign_in_page.dart';
import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/auth/data/repositories/auth_repository.dart';
import 'package:kastelli/features/auth/presentation/providers/user_provider.dart';
import 'package:kastelli/features/home/presentation/pages/main_page.dart';
import 'package:kastelli/features/home/presentation/providers/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<bool?> showSignOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Container(
          color: AppColors.white,
          padding: EdgeInsets.all(22.w),
          height: 200.h,
          width: 270.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/img/icon (1).png"),
              const Text(
                AppStrings.signOutConfirm,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true);
                    },
                    child: const Text(
                      AppStrings.cancel,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () async {
                      final navigation = context.read<NavigationProvider>();
                      final userProvider = context.read<UserProvider>();
                      final navigator = Navigator.of(context);

                      await sl<AuthRepository>().logout();

                      userProvider.loadUserData();
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SignInPage()),
                        (route) => false,
                      );
                      navigation.changeTab(MainPage.homeTab);
                    },
                    child: const Text(
                      AppStrings.sure,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
