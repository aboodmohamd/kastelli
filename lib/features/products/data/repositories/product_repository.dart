import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/network/api_client.dart';
import 'package:kastelli/core/network/api_endpoints.dart';
import 'package:kastelli/core/network/response_wrapper.dart';

import 'package:kastelli/features/products/data/models/product_model.dart';
import 'package:kastelli/features/products/data/models/products_page_model.dart';

class ProductRepository {
  final ApiConsumer apiConsumer;

  ProductRepository({
    required this.apiConsumer,
  });

  Future<ProductsPageModel> getProductsPage({
    int page = 1,
    int categoryId = 0,
    String keyword = '',
    String sort = '',
    String order = '',
  }) async {
    final ResponseWrapper response = await apiConsumer.get(
      ApiEndpoints.products,
      queryParameters: {
        'category_id': categoryId,
        'page': page,
        'list_type': categoryId == 0 ? 3 : 1,
        if (keyword.isNotEmpty) 'keyword': keyword,
        if (sort.isNotEmpty) 'sort': sort,
        if (order.isNotEmpty) 'order': order,
      },
    );

    final data = response.data;
    if (data is! List || data.isEmpty || data.first is! Map) {
      throw Exception(AppStrings.loadProductsFailed);
    }

    final pageData = data.first as Map;
    final products = pageData['products'];

    return ProductsPageModel(
      products: products is List
          ? products
              .whereType<Map<String, dynamic>>()
              .map(ProductModel.fromJson)
              .toList()
          : [],
      hasMore: pageData['has_more'] == true,
    );
  }

  Future<List<ProductModel>> getProducts({
    int page = 1,
    int categoryId = 0,
  }) async {
    final result = await getProductsPage(page: page, categoryId: categoryId);
    return result.products;
  }
}
