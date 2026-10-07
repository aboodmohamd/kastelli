import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/products/data/models/product_details_model.dart';
import 'package:kastelli/features/products/data/models/product_model.dart';
import 'package:kastelli/features/products/data/repositories/product_details_repository.dart';
import 'package:flutter/material.dart';

class ProductDetailsProvider extends ChangeNotifier {
  ProductDetailsRepository get _detailsRepository =>
      sl<ProductDetailsRepository>();

  ProductDetailsModel? _details;
  bool _isLoadingDetails = false;
  String? _detailsError;
  int _quantity = 1;
  int _selectedSizeIndex = -1;
  int _selectedColorIndex = 0;
  bool _isExpanded = false;
  int _imageIndex = 0;
  int _requestId = 0;

  ProductDetailsModel? get details => _details;
  bool get isLoadingDetails => _isLoadingDetails;
  String? get detailsError => _detailsError;
  int get quantity => _quantity;
  int get selectedSizeIndex => _selectedSizeIndex;
  int get selectedColorIndex => _selectedColorIndex;
  bool get isExpanded => _isExpanded;
  int get imageIndex => _imageIndex;

  void openProduct(ProductModel? product) {
    _requestId++;
    _details = null;
    _detailsError = null;
    _quantity = 1;
    _selectedSizeIndex = -1;
    _selectedColorIndex = 0;
    _isExpanded = false;
    _imageIndex = 0;
    _isLoadingDetails = product != null;
    if (product != null) _loadDetails(product.productId);
  }

  Future<void> _loadDetails(String productId) async {
    final requestId = _requestId;
    try {
      final details =
          await _detailsRepository.getProductDetails(productId: productId);
      if (requestId != _requestId) return;
      _details = details;
    } catch (e) {
      if (requestId != _requestId) return;
      _detailsError = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoadingDetails = false;
    notifyListeners();
  }

  void selectSize(int index) {
    _selectedSizeIndex = index;
    notifyListeners();
  }

  void selectColor(int index) {
    _selectedColorIndex = index;
    notifyListeners();
  }

  void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void toggleDescription() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void changeImageIndex(int index) {
    _imageIndex = index;
    notifyListeners();
  }
}
