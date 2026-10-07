import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/features/home/presentation/pages/main_page.dart';
import 'package:kastelli/features/auth/presentation/pages/sign_in_page.dart';
import 'package:kastelli/features/auth/presentation/providers/sign_up_provider.dart';
import 'package:kastelli/features/auth/presentation/providers/user_provider.dart';

import 'package:kastelli/core/helpers/validators.dart';
import 'package:kastelli/core/shared/widgets/check_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

void _hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isAgreed = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _onSignUp() async {
    _hideKeyboard(context);

    if (nameController.text.trim().isEmpty ||
        dateOfBirthController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      _showError(AppStrings.fillAllFields);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _showError(AppStrings.passwordsDoNotMatch);
      return;
    }

    try {
      await context.read<SignUpProvider>().register(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            countryCode: "970",
            telephone: phoneController.text.trim(),
            dateOfBirth: dateOfBirthController.text.trim(),
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
      if (!mounted) return;
      _showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signUp = context.watch<SignUpProvider>();

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
                        AppStrings.signUp,
                        style: TextStyle(
                          fontSize: 33.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24.h),
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
                                controller: nameController,
                                decoration: InputDecoration(
                                  hintText: AppStrings.nameHint,
                                  hintStyle: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  suffixIcon: CheckIcon(
                                    controller: nameController,
                                    validator: Validators.isName,
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
                                AppStrings.nameLabel,
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
                      SizedBox(height: 24.h),
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
                                controller: dateOfBirthController,
                                readOnly: true,
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    final day =
                                        picked.day.toString().padLeft(2, '0');
                                    final month =
                                        picked.month.toString().padLeft(2, '0');
                                    dateOfBirthController.text =
                                        '$day-$month-${picked.year}';
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: AppStrings.dateOfBirthHint,
                                  hintStyle: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  suffixIcon: CheckIcon(
                                    controller: dateOfBirthController,
                                    validator: Validators.isDate,
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
                                AppStrings.dateOfBirthLabel,
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
                      SizedBox(height: 24.h),
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
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: AppStrings.phoneHint,
                                  hintStyle: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  suffixIcon: CheckIcon(
                                    controller: phoneController,
                                    validator: Validators.isPhone,
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
                                AppStrings.phoneLabel,
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
                      SizedBox(height: 24.h),
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
                                decoration: InputDecoration(
                                  hintText: AppStrings.emailHint,
                                  hintStyle: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  suffixIcon: CheckIcon(
                                      controller: emailController,
                                      validator: Validators.isEmail),
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
                      SizedBox(height: 24.h),
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
                                obscureText: !signUp.isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: AppStrings.passwordHint,
                                  hintStyle: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => context
                                        .read<SignUpProvider>()
                                        .togglePasswordVisibility(),
                                    icon: Icon(
                                      signUp.isPasswordVisible
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
                      SizedBox(height: 24.h),
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
                                controller: confirmPasswordController,
                                obscureText: !signUp.isConfirmPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: AppStrings.confirmPasswordHint,
                                  hintStyle: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => context
                                        .read<SignUpProvider>()
                                        .toggleConfirmPasswordVisibility(),
                                    icon: Icon(
                                      signUp.isConfirmPasswordVisible
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
                                AppStrings.confirmPasswordLabel,
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
                      SizedBox(height: 32.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(AppColors.black),
                            padding: WidgetStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: 56.w,
                                vertical: 12.h,
                              ),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),
                          ),
                          onPressed: signUp.isLoading ? null : _onSignUp,
                          child: signUp.isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.white)
                              : Text(
                                  AppStrings.signUp,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 20.sp,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(AppStrings.haveAccount),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInPage(),
                                ),
                              );
                            },
                            child: const Text(AppStrings.signIn),
                          ),
                        ],
                      ),
                      SizedBox(height: 48.h),
                      const Text(AppStrings.signInWithSocial),
                      SizedBox(height: 8.h),
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
              )),
        ),
      ),
    );
  }
}
