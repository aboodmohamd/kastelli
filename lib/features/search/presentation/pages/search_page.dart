import 'package:kastelli/core/shared/widgets/cart_icon_button.dart';
import 'package:kastelli/core/theme/app_colors.dart';
import 'package:kastelli/core/constants/app_strings.dart';

import 'package:kastelli/core/shared/widgets/app_drawer.dart';
import 'package:kastelli/core/shared/widgets/product_card.dart';
import 'package:kastelli/features/search/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.text = context.read<SearchProvider>().text;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchProvider>().clearSearch();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      context.read<SearchProvider>().loadNextPage();
    }
  }

  Widget _buildMessage(IconData icon, String text) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56.sp, color: AppColors.greyMedium),
            SizedBox(height: 12.h),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp, color: AppColors.greyDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(SearchProvider search) {
    if (search.isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (search.error != null) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            Text(
              search.error!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.error),
            ),
            TextButton(
                onPressed: () => context.read<SearchProvider>().loadNextPage(),
                child: const Text(AppStrings.retry)),
          ],
        ),
      );
    }
    if (!search.hasMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: Text(
            AppStrings.noMoreResults,
            style: TextStyle(fontSize: 13.sp, color: AppColors.grey),
          ),
        ),
      );
    }
    return SizedBox(height: 16.h);
  }

  Widget _buildBody(SearchProvider search) {
    if (search.query.isEmpty) {
      return _buildMessage(Icons.search, AppStrings.searchForProducts);
    }
    if (search.products.isEmpty && search.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (search.products.isEmpty && search.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(search.error!, textAlign: TextAlign.center),
            TextButton(
                onPressed: () => context.read<SearchProvider>().loadNextPage(),
                child: const Text(AppStrings.retry)),
          ],
        ),
      );
    }
    if (search.products.isEmpty) {
      return _buildMessage(
          Icons.search_off, AppStrings.noResultsFor(search.query));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final int columnCount = constraints.maxWidth >= 520 ? 3 : 2;
          final double horizontalSpacing = 8.w;
          final double verticalSpacing = 12.h;
          const double cardAspectRatio = 0.62;
          final double cardWidth =
              (constraints.maxWidth - horizontalSpacing * (columnCount - 1)) /
                  columnCount;
          final double cardHeight = cardWidth / cardAspectRatio;

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
                        product: search.products[index],
                      ),
                    );
                  },
                  childCount: search.products.length,
                ),
              ),
              SliverToBoxAdapter(child: _buildFooter(search)),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: TextFormField(
          controller: _searchController,
          onChanged: (value) =>
              context.read<SearchProvider>().onQueryChanged(value),
          onFieldSubmitted: (value) =>
              context.read<SearchProvider>().onQuerySubmitted(value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: AppStrings.searchHint,
            hintStyle: TextStyle(fontSize: 14.sp),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: AppColors.black, size: 20.sp),
            suffixIcon: search.text.isEmpty
                ? null
                : IconButton(
                    onPressed: _clearSearch,
                    icon: Icon(Icons.close, color: AppColors.grey, size: 20.sp),
                  ),
          ),
        ),
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
      body: _buildBody(search),
    );
  }
}
