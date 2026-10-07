import 'package:kastelli/core/shared/widgets/cart_icon_button.dart';
import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kastelli/features/cart/data/models/cart_item_model.dart';
import 'package:kastelli/features/cart/presentation/providers/cart_provider.dart';
import 'package:kastelli/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:kastelli/features/products/data/models/product_model.dart';
import 'package:kastelli/features/products/data/models/size_option_model.dart';
import 'package:kastelli/features/products/presentation/providers/product_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailsPage({super.key, this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  late final ProductDetailsProvider _provider =
      context.read<ProductDetailsProvider>();

  List<String> get _images {
    final detailsImages = _provider.details?.images ?? [];
    if (detailsImages.isNotEmpty) return detailsImages;
    return widget.product?.images ?? [];
  }

  int get _slidesCount => _images.isEmpty ? 1 : _images.length;

  List<SizeOptionModel> get _sizes => _provider.details?.sizes ?? [];

  List<String> get _colors {
    final color = _provider.details?.color ?? '';
    return color.isEmpty ? [] : [color];
  }

  String get _name =>
      _provider.details?.name ?? widget.product?.name ?? "Spring leather coat";

  SizeOptionModel? get _selectedSizeOption =>
      _provider.selectedSizeIndex >= 0 &&
              _provider.selectedSizeIndex < _sizes.length
          ? _sizes[_provider.selectedSizeIndex]
          : null;

  double get _baseUnitPrice {
    final price = _provider.details?.price ?? widget.product?.price ?? 120.0;
    final special = _provider.details?.special ?? widget.product?.special ?? 0;
    return special > 0 && special < price ? special : price;
  }

  String get _priceText {
    final currency =
        _provider.details?.currency ?? widget.product?.currency ?? '';
    final finalPrice = _baseUnitPrice;
    return '${finalPrice.toStringAsFixed(0)} $currency';
  }

  String get _ratingText => (_provider.details?.rating ?? 0).toStringAsFixed(1);

  String get _description {
    final detailsDescription = _provider.details?.description ?? '';
    if (detailsDescription.isNotEmpty) return detailsDescription;
    return widget.product?.description ?? '';
  }

  bool get _showSizes =>
      _provider.isLoadingDetails ||
      _provider.detailsError != null ||
      _sizes.isNotEmpty;

  Color _colorFromName(String name) {
    switch (name.trim().toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'off white':
      case 'off-white':
      case 'ivory':
        return AppColors.swatchOffWhite;
      case 'green':
        return Colors.green;
      case 'olive':
        return AppColors.swatchOlive;
      case 'red':
        return Colors.red;
      case 'burgundy':
      case 'maroon':
        return AppColors.swatchBurgundy;
      case 'pink':
        return Colors.pink.shade200;
      case 'blue':
        return Colors.blue;
      case 'navy':
        return AppColors.swatchNavy;
      case 'beige':
        return AppColors.swatchBeige;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      case 'yellow':
        return Colors.amber;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      default:
        return AppColors.accentLight;
    }
  }

  @override
  void initState() {
    super.initState();
    _provider.openProduct(widget.product);
  }

  Future<void> _addToCart() async {
    final product = widget.product;
    if (product == null) return;

    final selectedOption = _selectedSizeOption;
    if (_provider.details?.isOutOfStock == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.outOfStock)),
      );
      return;
    }
    if (_provider.details?.isSizeRequired == true && selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.selectSize)),
      );
      return;
    }

    await context.read<CartProvider>().addToCart(
          CartItemModel(
            productId: product.productId,
            name: _name,
            currency: _provider.details?.currency ?? product.currency,
            optionId: selectedOption?.optionId ??
                _provider.details?.productOptionId ??
                '',
            quantity: _provider.quantity,
            size: selectedOption?.label ?? '',
            price: _baseUnitPrice,
            image: _images.isNotEmpty ? _images.first : product.thumbnailUrl,
          ),
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.addedToCart)),
    );
  }

  Widget _buildSizes() {
    if (_provider.isLoadingDetails) {
      return SizedBox(
        height: 45.h,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (_provider.detailsError != null) {
      return Text(
        _provider.detailsError!,
        style: TextStyle(fontSize: 14.sp, color: AppColors.error),
      );
    }

    return Row(
      children: List.generate(_sizes.length, (index) {
        final size = _sizes[index];
        bool isActive = _provider.selectedSizeIndex == index;

        return GestureDetector(
          onTap: size.isAvailable ? () => _provider.selectSize(index) : null,
          child: Opacity(
            opacity: size.isAvailable ? 1 : 0.35,
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1.w,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    size.label,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppColors.white,
                        size: 24.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildColors() {
    return Row(
      children: List.generate(_colors.length, (index) {
        final name = _colors[index];
        final swatch = _colorFromName(name);
        bool isActive = _provider.selectedColorIndex == index;

        return GestureDetector(
          onTap: () => _provider.selectColor(index),
          child: Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Column(
              children: [
                Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: swatch,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.grey.withValues(alpha: 0.3),
                      width: 1.w,
                    ),
                  ),
                  child: isActive
                      ? Icon(
                          Icons.check,
                          color: swatch.computeLuminance() > 0.5
                              ? AppColors.black
                              : AppColors.white,
                          size: 24.sp,
                        )
                      : const SizedBox(),
                ),
                SizedBox(height: 4.h),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSubtitle,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProductDetailsProvider>();
    final isFav = widget.product != null &&
        context.watch<WishlistProvider>().isInWishlist(widget.product!);
    return Scaffold(
      appBar: AppBar(
        actions: [const CartIconButton()],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 500.h,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          enableInfiniteScroll: _slidesCount > 1,
                          onPageChanged: (index, reason) {
                            _provider.changeImageIndex(index);
                          },
                        ),
                        items: List.generate(_slidesCount, (index) {
                          return Container(
                            width: 1.sw,
                            color: AppColors.loadingBackground,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: _images.isEmpty
                                      ? const Icon(
                                          Icons.image_outlined,
                                          color: AppColors.iconPlaceholder,
                                          size: 48,
                                        )
                                      : Image.network(
                                          _images[index],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                            Icons.broken_image_outlined,
                                            color: AppColors.iconPlaceholder,
                                            size: 48,
                                          ),
                                        ),
                                ),
                                Positioned(
                                  bottom: 20.h,
                                  right: 30.w,
                                  child: IconButton(
                                    onPressed: widget.product == null
                                        ? null
                                        : () => context
                                            .read<WishlistProvider>()
                                            .toggleWishlist(widget.product!),
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border_outlined,
                                      color: isFav
                                          ? AppColors.favorite
                                          : AppColors.grey,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                      if (_slidesCount > 1)
                        Positioned(
                          bottom: 30.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_slidesCount, (index) {
                              return GestureDetector(
                                onTap: () =>
                                    _carouselController.animateToPage(index),
                                child: Container(
                                  width: 8.w,
                                  height: 8.h,
                                  margin: EdgeInsets.only(right: 6.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _provider.imageIndex == index
                                        ? AppColors.textDark
                                        : AppColors.white,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          icon: Icon(
                            Icons.star,
                            color: AppColors.textSubtitle,
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
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(11.r),
                    width: 0.95.sw,
                    height: 60.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.grey, width: 0.9.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _priceText,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _provider.decreaseQuantity,
                                icon: const Icon(
                                  Icons.remove,
                                  size: 20,
                                  color: AppColors.black,
                                ),
                              ),
                              Text("${_provider.quantity}"),
                              IconButton(
                                onPressed: _provider.increaseQuantity,
                                icon: const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  if (_showSizes) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.sizeTitle,
                            style: TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _buildSizes(),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                  if (_colors.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.colorTitle,
                            style: TextStyle(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _buildColors(),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.descriptionTitle,
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: _provider.isExpanded
                                ? [AppColors.white, AppColors.white]
                                : [AppColors.white, Colors.transparent],
                            stops: const [0.7, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Text(
                          _description,
                          maxLines: _provider.isExpanded ? null : 4,
                          overflow: _provider.isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextButton.icon(
                        iconAlignment: IconAlignment.end,
                        onPressed: _provider.toggleDescription,
                        label: Text(
                          AppStrings.readMore,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16.sp,
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.primary,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.h, left: 16.w, right: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: widget.product == null ||
                          _provider.isLoadingDetails ||
                          _provider.detailsError != null
                      ? null
                      : _addToCart,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.black),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(
                        horizontal: 0.30.sw,
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
                    AppStrings.addToCart,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 19.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
