import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/products/data/models/product_model.dart';
import 'package:kastelli/features/products/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  ProductRepository get _productRepository => sl<ProductRepository>();

  final List<ProductModel> _products = [];
  int _categoryId = 0;
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  int _requestId = 0;
  int _sortIndex = 0;

  static const List<Map<String, String>> _sortParams = [
    {'sort': '', 'order': ''},
    {'sort': 'price', 'order': 'asc'},
    {'sort': 'price', 'order': 'desc'},
    {'sort': 'created_at', 'order': 'desc'},
  ];

  List<ProductModel> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  int get sortIndex => _sortIndex;

  void changeSort(int index) {
    if (index == _sortIndex) return;
    _sortIndex = index;
    _requestId++;
    _products.clear();
    _page = 1;
    _hasMore = true;
    _error = null;
    _isLoading = true;
    notifyListeners();
    _fetchPage();
  }

  void openCategory(int categoryId) {
    _requestId++;
    _categoryId = categoryId;
    _sortIndex = 0;
    _products.clear();
    _page = 1;
    _hasMore = true;
    _error = null;
    _isLoading = true;
    _fetchPage();
  }

  Future<void> loadNextPage() async {
    if (_isLoading || !_hasMore) return;
    _isLoading = true;
    _error = null;
    notifyListeners();
    await _fetchPage();
  }

  Future<void> _fetchPage() async {
    final requestId = _requestId;
    try {
      final result = await _productRepository.getProductsPage(
        page: _page,
        categoryId: _categoryId,
        sort: _sortParams[_sortIndex]['sort']!,
        order: _sortParams[_sortIndex]['order']!,
      );
      if (requestId != _requestId) return;

      final existingIds = _products.map((p) => p.productId).toSet();
      _products.addAll(
        result.products.where((p) => !existingIds.contains(p.productId)),
      );
      _hasMore = result.hasMore && result.products.isNotEmpty;
      _page++;
    } catch (e) {
      if (requestId != _requestId) return;
      _error = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
  }
}
