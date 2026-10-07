import 'package:kastelli/features/products/data/models/size_option_model.dart';

class ProductDetailsModel {
  final String name;

  final String productId;
  final double price;
  final double special;
  final double rating;
  final String currency;
  final String color;
  final String productOptionId;
  final String sizeGuideUrl;

  final bool isSizeRequired;
  final bool isOutOfStock;
  final String description;
  final List<String> images;
  final String sku;
  final List<SizeOptionModel> sizes;

  ProductDetailsModel({
    required this.name,
    required this.sizeGuideUrl,
    required this.rating,
    required this.isOutOfStock,
    required this.productId,
    required this.price,
    required this.currency,
    required this.color,
    required this.sizes,
    required this.productOptionId,
    required this.isSizeRequired,
    required this.special,
    required this.description,
    required this.images,
    required this.sku,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final images = rawImages is List
        ? rawImages
            .whereType<Map>()
            .map((image) => image['url']?.toString() ?? '')
            .where((url) => url.isNotEmpty)
            .toList()
        : <String>[];
    final mainImage = json['image']?.toString() ?? '';

    final options = json['options'];
    final firstOption =
        options is List && options.isNotEmpty && options.first is Map
            ? options.first as Map
            : null;
    final variants = firstOption?['variants'];
    final sizes = variants is List
        ? variants
            .whereType<Map<String, dynamic>>()
            .map(SizeOptionModel.fromJson)
            .toList()
        : <SizeOptionModel>[];

    final description = _attributeText(json, 'description');

    return ProductDetailsModel(
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      special: double.tryParse(json['special']?.toString() ?? '') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 0,
      currency: json['currency']?.toString() ?? '',
      sizeGuideUrl: json['size_guide']?.toString() ?? '',
      isOutOfStock: json['is_out_of_stock'] == true,
      images: images.isEmpty && mainImage.isNotEmpty ? [mainImage] : images,
      description: description.isNotEmpty
          ? description
          : json['meta_description']?.toString() ?? '',
      color: _attributeText(json, 'color_0'),
      sizes: sizes,
      productOptionId: firstOption?['product_option_id']?.toString() ?? '',
      isSizeRequired: firstOption?['required']?.toString() == '1',
    );
  }

  static String _attributeText(Map<String, dynamic> json, String name) {
    final groups = json['attributes'];
    if (groups is! List || groups.isEmpty || groups.first is! Map) return '';

    final attributes = (groups.first as Map)['attribute'];
    if (attributes is! List) return '';

    for (final attribute in attributes.whereType<Map>()) {
      if (attribute['name'] == name) {
        return attribute['text']?.toString() ?? '';
      }
    }
    return '';
  }
}
