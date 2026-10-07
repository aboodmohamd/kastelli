import 'package:kastelli/core/constants/app_strings.dart';
import 'package:kastelli/core/network/api_client.dart';
import 'package:kastelli/core/network/api_endpoints.dart';
import 'package:kastelli/core/network/response_wrapper.dart';
import 'package:kastelli/features/products/data/models/product_details_model.dart';

class ProductDetailsRepository {
  final ApiConsumer apiConsumer;

  ProductDetailsRepository({
    required this.apiConsumer,
  });

  Future<ProductDetailsModel> getProductDetails({
    required String productId,
  }) async {
    final ResponseWrapper response = await apiConsumer.get(
      ApiEndpoints.productDetails,
      queryParameters: {'product_id': productId},
    );

    final data = response.data;
    if (data is! List || data.isEmpty || data.first is! Map<String, dynamic>) {
      throw Exception(AppStrings.loadProductDetailsFailed);
    }

    return ProductDetailsModel.fromJson(data.first as Map<String, dynamic>);
  }
}
