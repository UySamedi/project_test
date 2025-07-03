import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await ApiService.fetchProducts();
    } catch (e) {
      _error = 'Error fetching products: $e';
      print('Fetch error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newProduct = await ApiService.addProduct(product);
      _products.add(newProduct);
    } catch (e) {
      _error = 'Error adding product: $e';
      print('Add error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProduct = await ApiService.updateProduct(product);
      final index = _products.indexWhere((p) => p.id == updatedProduct.id);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
    } catch (e) {
      _error = 'Error updating product: $e';
      print('Update error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProduct(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
    } catch (e) {
      _error = 'Error deleting product: $e';
      print('Delete error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}