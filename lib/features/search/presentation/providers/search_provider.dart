import 'dart:async';

import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/products/data/models/product_model.dart';
import 'package:kastelli/features/products/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  ProductRepository get _productRepository => sl<ProductRepository>();

  final List<ProductModel> _products = [];
  String _text = '';
  String _query = '';
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;

  Timer? _debounce;

  int _requestId = 0;

  List<ProductModel> get products => List.unmodifiable(_products);
  String get text => _text;
  String get query => _query;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  void onQueryChanged(String value) {
    _text = value;
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => startSearch(value),
    );
    notifyListeners();
  }

  void onQuerySubmitted(String value) {
    _debounce?.cancel();
    startSearch(value);
  }

  void clearSearch() {
    _debounce?.cancel();
    _text = '';
    startSearch('');
    notifyListeners();
  }

  void startSearch(String value) {
    final query = value.trim();
    if (query == _query) return;

    _requestId++;
    _query = query;
    _products.clear();
    _page = 1;
    _hasMore = true;
    _isLoading = false;
    _error = null;
    notifyListeners();

    if (query.isNotEmpty) loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (_query.isEmpty || _isLoading || !_hasMore) return;

    final requestId = _requestId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _productRepository.getProductsPage(
        page: _page,
        keyword: _query,
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
