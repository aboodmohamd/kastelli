import 'package:kastelli/core/database/app_database.dart';
import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/cart/data/models/cart_item_model.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  AppDatabase get _db => sl<AppDatabase>();
  bool _hasLoaded = false;
  bool isLoading = false;

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get totalQuantity =>
      _items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice => _items.fold(0, (total, item) => total + item.total);

  Future<void> loadCart() async {
    isLoading = true;
    notifyListeners();

    try {
      final rows = await _db.getCart();
      _items
        ..clear()
        ..addAll(rows.map(CartItemModel.fromRow));
      _hasLoaded = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart(CartItemModel item) async {
    await _ensureLoaded();
    final index = _findItemIndex(item.productId, item.size);
    final amount = item.quantity > 0 ? item.quantity : 1;

    if (index == -1) {
      final newItem = _withQuantity(item, amount);
      _items.add(newItem);
      notifyListeners();
      await _db.insertCart(newItem.toRow());
    } else {
      final currentItem = _items[index];
      _items[index] = _withQuantity(
        currentItem,
        currentItem.quantity + amount,
      );
      notifyListeners();
      await _db.updateProductQuantity(
        increment: true,
        productId: item.productId,
        size: item.size,
        amount: amount,
      );
    }
  }

  Future<void> increaseQuantity({
    required String productId,
    required String size,
  }) async {
    await _changeQuantity(productId: productId, size: size, increment: true);
  }

  Future<void> decreaseQuantity({
    required String productId,
    required String size,
  }) async {
    await _changeQuantity(productId: productId, size: size, increment: false);
  }

  Future<void> removeFromCart({
    required String productId,
    required String size,
  }) async {
    await _ensureLoaded();
    _items.removeWhere(
      (item) => item.productId == productId && item.size == size,
    );
    notifyListeners();
    await _db.deleteCartItem(productId: productId, size: size);
  }

  Future<void> clearCart() async {
    await _ensureLoaded();
    _items.clear();
    notifyListeners();
    await _db.delete(tableName: 'cart');
  }

  Future<void> _changeQuantity({
    required String productId,
    required String size,
    required bool increment,
  }) async {
    await _ensureLoaded();
    final index = _findItemIndex(productId, size);
    if (index == -1) return;

    final item = _items[index];
    if (!increment && item.quantity <= 1) return;

    _items[index] = _withQuantity(
      item,
      item.quantity + (increment ? 1 : -1),
    );
    notifyListeners();
    await _db.updateProductQuantity(
      increment: increment,
      productId: productId,
      size: size,
    );
  }

  Future<void> _ensureLoaded() async {
    if (!_hasLoaded) await loadCart();
  }

  int _findItemIndex(String productId, String size) {
    return _items.indexWhere(
      (item) => item.productId == productId && item.size == size,
    );
  }

  CartItemModel _withQuantity(CartItemModel item, int quantity) {
    return CartItemModel(
      productId: item.productId,
      name: item.name,
      currency: item.currency,
      optionId: item.optionId,
      quantity: quantity,
      size: item.size,
      price: item.price,
      image: item.image,
    );
  }
}
