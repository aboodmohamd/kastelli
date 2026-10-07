import 'package:kastelli/core/database/app_database.dart';
import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];
  AppDatabase get _db => sl<AppDatabase>();

  bool _isLoading = false;

  List<ProductModel> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  bool isInWishlist(ProductModel product) {
    return _items.any((p) => p.productId == product.productId);
  }

  Future<void> loadWishlist() async {
    _isLoading = true;
    notifyListeners();
    final rows = await _db.getWishlist();
    _items
      ..clear()
      ..addAll(rows.map(_fromRow));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleWishlist(ProductModel product) async {
    if (isInWishlist(product)) {
      _items.removeWhere((p) => p.productId == product.productId);
      notifyListeners();
      await _db.deleteFromWishlist(product.productId);
    } else {
      _items.add(product);
      notifyListeners();
      await _db.insertWishlist(_toRow(product));
    }
  }

  Map<String, dynamic> _toRow(ProductModel product) {
    return {
      'productId': product.productId,
      'name': product.name,
      'price': product.price,
      'special': product.special,
      'currency': product.currency,
      'image': product.thumbnailUrl,
      'rate': 0,
    };
  }

  ProductModel _fromRow(Map<String, dynamic> row) {
    final image = row['image']?.toString() ?? '';
    return ProductModel(
      productId: row['productId']?.toString() ?? '',
      name: row['name']?.toString() ?? '',
      price: (row['price'] as num?)?.toDouble() ?? 0,
      special: (row['special'] as num?)?.toDouble() ?? 0,
      currency: row['currency']?.toString() ?? '',
      thumbnailUrl: image,
      images: image.isEmpty ? [] : [image],
      label: '',
      showLabel: false,
      description: '',
      sku: '',
    );
  }
}
