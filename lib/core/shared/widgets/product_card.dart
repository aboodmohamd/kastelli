import 'package:kastelli/core/theme/app_colors.dart';
import "package:kastelli/features/wishlist/presentation/providers/wishlist_provider.dart";
import "package:kastelli/features/products/presentation/pages/product_details_page.dart";
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:kastelli/features/products/data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final double width;
  final double height;
  final String? imagePath;

  final ProductModel? product;

  const ProductCard({
    super.key,
    required this.height,
    required this.width,
    this.product,
    this.imagePath,
  });

  static double widthForHeight(double cardHeight) {
    final double textHeight = 6.h + (12.sp + 14.sp) * 1.2;
    return (cardHeight - 5.h - textHeight) * 2 / 3;
  }

  @override
  Widget build(BuildContext context) {
    final product = this.product;
    final isFav = product != null &&
        context.watch<WishlistProvider>().isInWishlist(product);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailsPage(
                    product: product,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.h),
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: AppColors.accentLight,
                      child: product == null
                          ? const Icon(
                              Icons.image_outlined,
                              color: AppColors.iconPlaceholder,
                              size: 42,
                            )
                          : Image.network(
                              product.thumbnailUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.iconPlaceholder,
                                size: 42,
                              ),
                            ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: product == null
                            ? null
                            : () => context
                                .read<WishlistProvider>()
                                .toggleWishlist(product),
                        icon: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: isFav ? AppColors.favorite : AppColors.grey,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () => Navigator.push(
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
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product?.name ?? "Long summer dress",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    product == null
                        ? '\$120.00'
                        : '${product.price.toStringAsFixed(0)} ${product.currency}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.black,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
