class CartItemModel {
  final String productId;
  final String name;
  final String currency;
  final String optionId;
  final int quantity;
  final String size;
  final double price;
  final String image;
  double get total => price * quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.currency,
    required this.optionId,
    required this.quantity,
    required this.price,
    required this.image,
    required this.size,
  });

  Map<String, dynamic> toRow() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'optionId': optionId,
      'currency': currency,
      'image': image,
      'quantity': quantity,
      'size': size,
    };
  }

  factory CartItemModel.fromRow(Map<String, dynamic> row) {
    return CartItemModel(
      productId: row['productId']?.toString() ?? '',
      name: row['name']?.toString() ?? '',
      price: (row['price'] as num?)?.toDouble() ?? 0,
      currency: row['currency']?.toString() ?? '',
      optionId: row['optionId']?.toString() ?? '',
      quantity: (row['quantity'] as num?)?.toInt() ?? 1,
      image: row['image']?.toString() ?? '',
      size: row['size']?.toString() ?? '',
    );
  }
}
