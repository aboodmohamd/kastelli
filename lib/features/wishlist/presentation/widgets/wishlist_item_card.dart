import 'package:kastelli/features/products/presentation/pages/product_details_page.dart';
import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:kastelli/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistItemCard extends StatelessWidget {
  final ProductModel? product;
  const WishlistItemCard({super.key, this.product});

  List<String> get _images => product?.images ?? [];

  String get _name => product?.name ?? "Spring leather coat";

  String get _priceText {
    final product = this.product;
    if (product == null) return '\$120.00';

    final special = product.special;
    final finalPrice =
        special > 0 && special < product.price ? special : product.price;
    return '${finalPrice.toStringAsFixed(0)} ${product.currency}';
  }

  String get _ratingText => '0.0';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 0.16.sh,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: double.infinity,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                color: AppColors.imagePlaceholder,
                child: _images.isEmpty
                    ? const Icon(
                        Icons.image_outlined,
                        color: AppColors.iconPlaceholder,
                        size: 48,
                      )
                    : Image.network(
                        _images[0],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.iconPlaceholder,
                          size: 48,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(12.w, 12.h, 0, 0),
              decoration: const BoxDecoration(
                border: Border.symmetric(horizontal: BorderSide(width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _name,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.accent,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            _priceText,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        icon: Icon(
                          Icons.star,
                          color: AppColors.textSubtitle,
                          size: 18.sp,
                        ),
                        onPressed: () {},
                        label: Text(
                          _ratingText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: product == null
                            ? null
                            : () => context
                                .read<WishlistProvider>()
                                .toggleWishlist(product!),
                        icon: Icon(
                          Icons.favorite,
                          color: AppColors.favorite,
                          size: 20.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: product == null
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailsPage(product: product),
                                  ),
                                ),
                        icon: Icon(
                          Icons.add,
                          color: AppColors.black,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
