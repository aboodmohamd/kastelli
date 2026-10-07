import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/features/cart/presentation/widgets/delete_item_dialog.dart';
import 'package:kastelli/features/cart/data/models/cart_item_model.dart';
import 'package:kastelli/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) => showDeleteItemDialog(context),
      key: ValueKey('${item.productId}_${item.size}'),
      direction: DismissDirection.endToStart,
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: AppColors.danger,
        child: Icon(Icons.delete_outline, color: AppColors.white, size: 26.sp),
      ),
      background: const SizedBox(),
      onDismissed: (direction) {
        context.read<CartProvider>().removeFromCart(
              productId: item.productId,
              size: item.size,
            );
      },
      child: SizedBox(
        width: double.infinity,
        height: 142.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: double.infinity,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: item.image.isEmpty
                    ? const ColoredBox(
                        color: AppColors.imagePlaceholder,
                        child: Icon(Icons.image_outlined,
                            color: AppColors.iconPlaceholder),
                      )
                    : Image.network(
                        item.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const ColoredBox(
                          color: AppColors.imagePlaceholder,
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.iconPlaceholder,
                          ),
                        ),
                      ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 0, 4.h),
                decoration: const BoxDecoration(
                  border: Border.symmetric(horizontal: BorderSide(width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${item.price.toStringAsFixed(2)} ${item.currency}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            item.size.isEmpty
                                ? AppStrings.standardSize
                                : AppStrings.sizeLabel(item.size),
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          tooltip: AppStrings.increaseQuantity,
                          onPressed: () =>
                              context.read<CartProvider>().increaseQuantity(
                                    productId: item.productId,
                                    size: item.size,
                                  ),
                          icon: Icon(
                            Icons.add,
                            size: 20.sp,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          '${item.quantity}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          tooltip: AppStrings.decreaseQuantity,
                          onPressed: () =>
                              context.read<CartProvider>().decreaseQuantity(
                                    productId: item.productId,
                                    size: item.size,
                                  ),
                          icon: Icon(
                            Icons.remove,
                            size: 20.sp,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
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
