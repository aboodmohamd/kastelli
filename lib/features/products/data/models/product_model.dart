class ProductModel {
  final String name;
  final String label;
  final String productId;
  final double price;
  final double special;
  final String currency;
  final String thumbnailUrl;
  final bool showLabel;
  final String description;
  final List<String> images;
  final String sku;

  ProductModel({
    required this.name,
    required this.label,
    required this.productId,
    required this.price,
    required this.currency,
    required this.special,
    required this.thumbnailUrl,
    required this.showLabel,
    required this.description,
    required this.images,
    required this.sku,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final labels = json['label'];
    final firstLabel =
        labels is List && labels.isNotEmpty && labels.first is Map
            ? labels.first['text']?.toString() ?? ''
            : '';
    final rawImages = json['images'];
    final imageUrls = rawImages is List
        ? rawImages
            .whereType<Map>()
            .map((image) => image['url']?.toString() ?? '')
            .where((url) => url.isNotEmpty)
            .toList()
        : <String>[];
    final thumbnail = json['thumbnail_url']?.toString() ?? '';
    return ProductModel(
      name: json['name']?.toString() ?? '',
      label: firstLabel,
      productId: json['product_id']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      special: double.tryParse(json['special']?.toString() ?? '') ?? 0,
      currency: json['currency']?.toString() ?? '',
      thumbnailUrl: json['thumbnail_url']?.toString() ?? '',
      showLabel: json['show_label'] == true,
      description: json['description']?.toString() ?? '',
      images:
          imageUrls.isEmpty && thumbnail.isNotEmpty ? [thumbnail] : imageUrls,
      sku: json['sku']?.toString() ?? '',
    );
  }
}
