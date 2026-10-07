class SizeOptionModel {
  final String optionId;
  final String label;
  final double price;
  final int availableQuantity;

  SizeOptionModel({
    required this.label,
    required this.availableQuantity,
    required this.price,
    required this.optionId,
  });

  bool get isAvailable => availableQuantity > 0;

  factory SizeOptionModel.fromJson(Map<String, dynamic> json) {
    return SizeOptionModel(
      label: json['label']?.toString() ?? '',
      optionId: json['option_id']?.toString() ?? '',
      price: double.tryParse(json['price_variance']?.toString() ?? '') ?? 0,
      availableQuantity:
          int.tryParse(json['available_quantity']?.toString() ?? '') ?? 0,
    );
  }
}
