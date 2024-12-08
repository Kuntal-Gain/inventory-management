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
  bool isProductExpanded(String sku) => _expandedProducts.contains(sku);

  // Toggle the expanded state of a product
  void toggleProductExpansion(String sku) {
    if (_expandedProducts.contains(sku)) {
      _expandedProducts.remove(sku);
    } else {
      _expandedProducts.add(sku);
    }
    notifyListeners();
  }

  // Load products from local storage
  Future<void> _loadProducts() async {
    try {
      List<Product> savedItems = await LocalStorageService.getProducts();
      _items = savedItems;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load products: $e');
    }
  }

  // Save products to local storage
  Future<void> _saveProducts() async {
    try {
      await LocalStorageService.saveProducts(_items);
    } catch (e) {
      debugPrint('Failed to save products: $e');
    }
  }

  // Add a new product
  void addProduct(Product product) {
    _items.add(product);
    _saveProducts();
    notifyListeners();
  }

  // Update an existing product
  void updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.sku == product.sku);
    if (index != -1) {
      _items[index] = product;
      _saveProducts();
      notifyListeners();
    }
  }

  // Remove a product
  void removeProduct(Product product) {
    _items.removeWhere((p) => p.sku == product.sku);
    _saveProducts();
    notifyListeners();
  }

  // Sell a product (decrease quantity)
  void sellProduct(Product product, {int quantity = 1}) {
    int index = _items.indexWhere((p) => p.sku == product.sku);
    if (index != -1 && _items[index].quantity >= quantity) {
      _items[index].quantity -= quantity;
      _saveProducts();
      notifyListeners();
    } else {
      debugPrint('Insufficient quantity for product: ${product.name}');
    }
  }

  // Restock a product (increase quantity)
  void restockProduct(Product product, {int quantity = 1}) {
    int index = _items.indexWhere((p) => p.sku == product.sku);
    if (index != -1) {
      _items[index].quantity += quantity;
      _saveProducts();
      notifyListeners();
    }
  }

  // Bulk sell products
  void sellProductsInBulk(Map<String, int> skuToQuantity) {
    for (var entry in skuToQuantity.entries) {
      int index = _items.indexWhere((p) => p.sku == entry.key);
      if (index != -1 && _items[index].quantity >= entry.value) {
        _items[index].quantity -= entry.value;
      } else {
        debugPrint('Insufficient quantity for product with SKU: ${entry.key}');
      }
    }
    _saveProducts();
    notifyListeners();
  }

  // Bulk restock products
  void restockProductsInBulk(Map<String, int> skuToQuantity) {
    for (var entry in skuToQuantity.entries) {
      int index = _items.indexWhere((p) => p.sku == entry.key);
      if (index != -1) {
        _items[index].quantity += entry.value;
      }
    }
    _saveProducts();
    notifyListeners();
  }
}
