import 'package:kastelli/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckIcon extends StatelessWidget {
  final TextEditingController controller;
  final bool Function(String) validator;

  const CheckIcon({
    super.key,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return validator(value.text)
            ? Icon(Icons.check, color: AppColors.success, size: 20.sp)
            : const SizedBox.shrink();
      },
    );
  }
}
