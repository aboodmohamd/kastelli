import 'package:kastelli/features/products/presentation/pages/products_page.dart';
import 'package:kastelli/core/shared/widgets/cart_icon_button.dart';
import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kastelli/core/shared/widgets/app_drawer.dart';
import 'package:kastelli/features/home/data/models/banner_image_model.dart';
import 'package:kastelli/features/home/presentation/providers/home_provider.dart';
import 'package:kastelli/core/shared/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<Map<String, dynamic>> bannerData = [
  {
    "title": AppStrings.bannerTitle1,
    "buttonText": AppStrings.shopNow,
    "color": AppColors.bannerBackground1,
    "image": "assets/img/banner_1.jpg",
  },
  {
    "title": AppStrings.bannerTitle2,
    "buttonText": AppStrings.discover,
    "color": AppColors.bannerBackground2,
    "image": "assets/img/banner_2.jpg",
  },
  {
    "title": AppStrings.bannerTitle3,
    "buttonText": AppStrings.shopNow,
    "color": AppColors.bannerBackground3,
    "image": "assets/img/banner_3.jpg",
  },
];

class _HomePageState extends State<HomePage> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  Widget _networkImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: AppColors.loadingBackground,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (context, error, stackTrace) => _localMiddleImage(),
    );
  }

  Widget _localMiddleImage() {
    return Image.asset(
      "assets/img/middle_banner.jpg",
      fit: BoxFit.cover,
    );
  }

  Widget _localBanner(int index) {
    final data = bannerData[index % bannerData.length];
    return Image.asset(
      data['image'],
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          Container(color: data['color']),
    );
  }

  Widget _bannerImage(BannerImageModel? banner, int index) {
    if (banner == null || banner.imageUrl.isEmpty) return _localBanner(index);
    return Image.network(
      banner.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _localBanner(index),
      errorBuilder: (context, error, stackTrace) => _localBanner(index),
    );
  }

  Widget _bannerSlide(int index, BannerImageModel? banner) {
    final data = bannerData[index % bannerData.length];
    return SizedBox(
      width: 1.sw,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _bannerImage(banner, index),
          Positioned(
            top: 30.h,
            right: 30.w,
            child: Image.asset("assets/img/logo.png"),
          ),
          Positioned(
            bottom: 50.h,
            left: 20.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 15.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.textDark),
                      bottom: BorderSide(color: AppColors.textDark),
                    ),
                  ),
                  child: Text(
                    data['buttonText'],
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: 1.2,
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

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.home),
        actions: [const CartIconButton()],
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Image.asset(
                "assets/img/Burger@2x.png",
                width: 25.w,
                height: 12.h,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Builder(
              builder: (context) {
                if (home.isLoadingDashboard) {
                  return SizedBox(
                    height: 500.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                final banners = home.dashboard?.topBanners ?? [];
                final int count = banners.length > bannerData.length
                    ? banners.length
                    : bannerData.length;

                return Stack(
                  children: [
                    CarouselSlider(
                      carouselController: _carouselController,
                      options: CarouselOptions(
                        height: 500.h,
                        viewportFraction: 1.0,
                        initialPage: home.bannerIndex,
                        enableInfiniteScroll: count > 1,
                        onPageChanged: (index, reason) {
                          context.read<HomeProvider>().changeBannerIndex(index);
                        },
                      ),
                      items: List.generate(
                        count,
                        (index) => _bannerSlide(
                          index,
                          index < banners.length ? banners[index] : null,
                        ),
                      ),
                    ),
                    if (count > 1)
                      Positioned(
                        bottom: 15.h,
                        left: 20.w,
                        child: Row(
                          children: List.generate(count, (index) {
                            return GestureDetector(
                              onTap: () =>
                                  _carouselController.animateToPage(index),
                              child: Container(
                                width: 8.w,
                                height: 8.h,
                                margin: EdgeInsets.only(right: 6.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: home.bannerIndex == index
                                      ? AppColors.textDark
                                      : AppColors.white,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 24.h),
            Builder(
              builder: (context) {
                if (home.isLoadingDashboard) return const SizedBox.shrink();

                final image = home.dashboard?.middleImage;

                return ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: SizedBox(
                    width: 355.w,
                    height: 200.h,
                    child: image == null || image.imageUrl.isEmpty
                        ? _localMiddleImage()
                        : _networkImage(image.imageUrl),
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.featuredProducts,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductsPage()),
                    ),
                    child: Text(
                      AppStrings.viewAll,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            SizedBox(
              height: 250.h,
              child: Builder(
                builder: (context) {
                  if (home.isLoadingProducts) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (home.productsError != null) {
                    return Center(child: Text(home.productsError!));
                  }

                  final products = home.products;

                  if (products.isEmpty) {
                    return const Center(
                        child: Text(AppStrings.noProductsFound));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (context, index) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final double cardHeight = 250.h;
                      return ProductCard(
                        width: ProductCard.widthForHeight(cardHeight),
                        height: cardHeight,
                        product: products[index],
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
