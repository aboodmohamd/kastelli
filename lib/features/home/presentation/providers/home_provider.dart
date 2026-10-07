import 'package:kastelli/core/di/service_locator.dart';
import 'package:kastelli/features/home/data/models/dashboard_model.dart';
import 'package:kastelli/features/home/data/repositories/dashboard_repository.dart';
import 'package:kastelli/features/products/data/models/product_model.dart';
import 'package:kastelli/features/products/data/repositories/product_repository.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  DashboardRepository get _dashboardRepository => sl<DashboardRepository>();
  ProductRepository get _productRepository => sl<ProductRepository>();

  DashboardModel? _dashboard;
  List<ProductModel> _products = [];
  bool _isLoadingDashboard = false;
  bool _isLoadingProducts = false;
  String? _productsError;
  int _bannerIndex = 0;

  DashboardModel? get dashboard => _dashboard;
  List<ProductModel> get products => _products;
  bool get isLoadingDashboard => _isLoadingDashboard;
  bool get isLoadingProducts => _isLoadingProducts;
  String? get productsError => _productsError;
  int get bannerIndex => _bannerIndex;

  Future<void> loadHome() async {
    await Future.wait([_loadDashboard(), _loadProducts()]);
  }

  Future<void> _loadDashboard() async {
    _isLoadingDashboard = true;
    notifyListeners();
    try {
      _dashboard = await _dashboardRepository.getDashboard();
    } catch (_) {
      _dashboard = null;
    }
    _isLoadingDashboard = false;
    notifyListeners();
  }

  Future<void> _loadProducts() async {
    _isLoadingProducts = true;
    notifyListeners();
    try {
      _products = await _productRepository.getProducts();
      _productsError = null;
    } catch (e) {
      _productsError = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  void changeBannerIndex(int index) {
    _bannerIndex = index;
    notifyListeners();
  }
}
