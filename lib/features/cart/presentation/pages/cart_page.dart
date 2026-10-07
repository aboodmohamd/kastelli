import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/shared/widgets/app_drawer.dart';
import 'package:kastelli/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:kastelli/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final currency = cart.items.isEmpty ? '' : cart.items.first.currency;
    const deliveryFee = 15.0;
    final subtotal = cart.totalPrice;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        shape: const Border(bottom: BorderSide(width: 0.05)),
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.cartTitle,
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                decoration: const BoxDecoration(
                  color: AppColors.black,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${cart.totalQuantity}',
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset(
              'assets/img/Burger@2x.png',
              width: 25.w,
              height: 12.h,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: cart.isLoading && cart.items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : cart.items.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 56.sp,
                          color: AppColors.accent,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          AppStrings.cartEmpty,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 28.h),
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cart.items.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) => CartItemCard(
                          item: cart.items[index],
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Container(
                        padding: EdgeInsets.all(19.w),
                        color: AppColors.accentLight,
                        child: Column(
                          children: [
                            _SummaryRow(
                              label: AppStrings.subtotal,
                              value: '$currency${subtotal.toStringAsFixed(2)}',
                            ),
                            SizedBox(height: 12.h),
                            _SummaryRow(
                              label: AppStrings.delivery,
                              value:
                                  '$currency${deliveryFee.toStringAsFixed(2)}',
                            ),
                            SizedBox(height: 12.h),
                            const Divider(),
                            SizedBox(height: 8.h),
                            _SummaryRow(
                              label: AppStrings.total,
                              value:
                                  '$currency${(subtotal + deliveryFee).toStringAsFixed(2)}',
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: const Text(AppStrings.proceedToCheckout),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: AppColors.primary,
      fontWeight: FontWeight.bold,
      fontSize: isTotal ? 18.sp : 16.sp,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: textStyle),
        Text(value, style: textStyle),
      ],
    );
  }
}
