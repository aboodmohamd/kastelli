import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/features/cart/presentation/providers/cart_provider.dart';
import 'package:kastelli/features/home/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartProvider>().totalQuantity;

    return GestureDetector(
      onTap: () => MainPage.openTab(context, MainPage.cartTab),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 20.r, minHeight: 20.r),
              padding: EdgeInsets.all(3.r),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$count',
                style: TextStyle(color: AppColors.white, fontSize: 11.sp),
              ),
            ),
            SvgPicture.asset("assets/img/shopping-cart.svg"),
          ],
        ),
      ),
    );
  }
}
