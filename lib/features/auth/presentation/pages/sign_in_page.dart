import 'package:kastelli/features/home/presentation/pages/main_page.dart';
import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/features/auth/presentation/pages/sign_up_page.dart';
import 'package:kastelli/features/auth/presentation/providers/sign_in_provider.dart';
import 'package:kastelli/features/auth/presentation/providers/user_provider.dart';
import 'package:kastelli/core/helpers/validators.dart';
import 'package:kastelli/core/shared/widgets/check_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _onLogin() async {
    _hideKeyboard(context);

    if (!_formKey.currentState!.validate()) return;

    try {
      await context.read<SignInProvider>().login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      if (!mounted) return;
      context.read<UserProvider>().loadUserData();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: MainPage.routeName),
          builder: (context) => const MainPage(),
        ),
      );
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signIn = context.watch<SignInProvider>();

    return GestureDetector(
      onTap: () => _hideKeyboard(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.white,
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            width: double.infinity,
            padding: EdgeInsets.only(top: 120.h),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.signInTitle,
                      style: TextStyle(
                        fontSize: 33.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      AppStrings.signInSubtitle,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textBody,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: AppColors.grey, width: 1.5),
                                bottom: BorderSide(
                                    color: AppColors.grey, width: 1.5),
                              ),
                            ),
                            child: TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.enterEmail;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: AppStrings.emailHint,
                                hintStyle: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                suffixIcon: CheckIcon(
                                  controller: emailController,
                                  validator: Validators.isEmail,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textBody,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2.h,
                          left: 12.w,
                          child: Container(
                            color: AppColors.white,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: const Text(
                              AppStrings.emailLabel,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: AppColors.grey, width: 1.5),
                                bottom: BorderSide(
                                    color: AppColors.grey, width: 1.5),
                              ),
                            ),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppStrings.enterPassword;
                                }
                                return null;
                              },
                              obscureText: !signIn.isPasswordVisible,
                              decoration: InputDecoration(
                                hintText: AppStrings.passwordHint,
                                hintStyle: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => context
                                      .read<SignInProvider>()
                                      .togglePasswordVisibility(),
                                  icon: Icon(
                                    signIn.isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.textBody,
                                    size: 20.sp,
                                  ),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 16.h,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textBody,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2.h,
                          left: 12.w,
                          child: Container(
                            color: AppColors.white,
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: const Text(
                              AppStrings.passwordLabel,
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: signIn.rememberMe,
                              activeColor: AppColors.darkNavy,
                              onChanged: (bool? newValue) => context
                                  .read<SignInProvider>()
                                  .toggleRememberMe(newValue!),
                            ),
                            Text(
                              AppStrings.rememberMe,
                              style: TextStyle(
                                  color: AppColors.black, fontSize: 14.sp),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            AppStrings.forgotPassword,
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppColors.black),
                          padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(
                              horizontal: 60.w,
                              vertical: 12.h,
                            ),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                        ),
                        onPressed: signIn.isLoading ? null : _onLogin,
                        child: signIn.isLoading
                            ? const CircularProgressIndicator(
                                color: AppColors.white)
                            : Text(
                                AppStrings.signIn,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 20.sp,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Text(
                          AppStrings.noAccount,
                          style: TextStyle(
                              color: AppColors.black, fontSize: 14.sp),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                            );
                          },
                          child: Text(
                            AppStrings.signUp,
                            style: TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 44.h),
                    Text(
                      AppStrings.signInWithSocial,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: AppColors.greyLight,
                                  width: 1.5,
                                ),
                              ),
                              child: Image.asset(
                                "assets/img/Group.png",
                                height: 22.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: AppColors.greyLight,
                                  width: 1.5,
                                ),
                              ),
                              child: Image.asset(
                                "assets/img/XMLID 826.png",
                                height: 22.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: AppColors.greyLight,
                                  width: 1.5,
                                ),
                              ),
                              child: Image.asset(
                                "assets/img/icon.png",
                                height: 22.h,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
