import 'package:kastelli/core/shared/widgets/cart_icon_button.dart';
import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/shared/widgets/product_card.dart';
import 'package:kastelli/features/products/presentation/providers/products_provider.dart';
import 'package:kastelli/features/products/presentation/widgets/sorting_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  final int categoryId;
  final String title;
  const ProductsPage({
    super.key,
    this.categoryId = 0,
    this.title = AppStrings.newArrivals,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ProductsProvider>().openCategory(widget.categoryId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<ProductsProvider>().loadNextPage();
    }
  }

  Widget _buildFooter(ProductsProvider productsProvider) {
    if (productsProvider.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (productsProvider.error != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            Text(
              productsProvider.error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.error),
            ),
            TextButton(
              onPressed: () => context.read<ProductsProvider>().loadNextPage(),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      );
    }
    if (!productsProvider.hasMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: Text(
            AppStrings.noMoreProducts,
            style: TextStyle(fontSize: 13.sp, color: AppColors.grey),
          ),
        ),
      );
    }
    return SizedBox(height: 16.h);
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();
    final products = productsProvider.products;

    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: Center(
            child: Text(
              widget.title,
              style: TextStyle(color: AppColors.black, fontSize: 17.sp),
            ),
          ),
          actions: [const CartIconButton()],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    "assets/img/akar-icons_settings-vertical (1).png",
                  ),
                  label: Text(
                    AppStrings.filters,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  iconAlignment: IconAlignment.end,
                  onPressed: () => showSortingDialog(context),
                  label: Text(
                    AppStrings.sortBy,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 16.sp,
                    ),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 16.sp,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final int columnCount = constraints.maxWidth >= 520 ? 3 : 2;
                final double horizontalSpacing = 8.w;
                final double verticalSpacing = 12.h;
                const double cardAspectRatio = 0.62;
                final double cardWidth = (constraints.maxWidth -
                        horizontalSpacing * (columnCount - 1)) /
                    columnCount;
                final double cardHeight = cardWidth / cardAspectRatio;
                if (products.isEmpty && productsProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (products.isEmpty && productsProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(productsProvider.error!,
                            textAlign: TextAlign.center),
                        TextButton(
                          onPressed: () =>
                              context.read<ProductsProvider>().loadNextPage(),
                          child: const Text(AppStrings.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (products.isEmpty) {
                  return const Center(child: Text(AppStrings.noProductsFound));
                }

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                        childAspectRatio: cardAspectRatio,
                        crossAxisSpacing: horizontalSpacing,
                        mainAxisSpacing: verticalSpacing,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return RepaintBoundary(
                            child: ProductCard(
                              height: cardHeight,
                              width: cardWidth,
                              product: products[index],
                            ),
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                    SliverToBoxAdapter(child: _buildFooter(productsProvider)),
                  ],
                );
              }),
            ),
          ]),
        ));
  }
}
