import 'package:flutter/material.dart';
import 'package:inventory_management/model/product.dart';
import 'package:inventory_management/services/local_storage_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _items = [];
  final Set<String> _expandedProducts = {}; // Track expanded products by SKU

  List<Product> get items => _items;

  ProductProvider() {
    _loadProducts();
  }

  // Check if a product is expanded
  bool isProductExpanded(String sku) {
    return _expandedProducts.contains(sku);
  }

  // Toggle the expanded state of a product
  void toggleProductExpansion(String sku) {
    if (_expandedProducts.contains(sku)) {
      _expandedProducts.remove(sku);
    } else {
      _expandedProducts.add(sku);
    }
    notifyListeners();
  }

  Future<void> _loadProducts() async {
    List<Product> savedItems = await LocalStorageService.getProducts();

    _items = savedItems;

    notifyListeners();
  }

  // Save
  Future<void> _saveProducts() async {
    await LocalStorageService.saveProducts(_items);
    notifyListeners();
  }

  // add product
  void addProduct(Product product) {
    _items.add(product);
    _saveProducts();
  }

  // update product
  void updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.sku == product.sku);
    if (index != -1) {
      _items[index] = product;
      _saveProducts();
    }
  }

  // Remove a product
  void removeProduct(Product product) {
    _items.remove(product);
    _saveProducts();
  }

  // Sell a product (decrease quantity)
  void sellProduct(Product product) {
    int index = _items.indexWhere((p) => p.sku == product.sku);
    if (index != -1 && _items[index].quantity > 0) {
      _items[index].quantity -= 1;
      _saveProducts();
    }
  }

  // Restock a product (increase quantity)
  void restockProduct(Product product) {
    int index = _items.indexWhere((p) => p.sku == product.sku);
    if (index != -1) {
      _items[index].quantity += 1;
      _saveProducts();
    }
  }
}
