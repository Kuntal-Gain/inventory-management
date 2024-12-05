import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_management/model/product.dart';

class LocalStorageService {
  // Key for storing products in SharedPreferences
  static const String _productKey = 'productList';

  // Save products to SharedPreferences
  static Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productJsonList =
        products.map((product) => product.toJson()).toList();
    await prefs.setString(_productKey, jsonEncode(productJsonList));
  }

  // Get products from SharedPreferences
  static Future<List<Product>> getProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productString = prefs.getString(_productKey);
    if (productString == null) return [];

    final List<dynamic> productJsonList = jsonDecode(productString);
    return productJsonList.map((json) => Product.fromJson(json)).toList();
  }

  // Remove all products from SharedPreferences
  static Future<void> clearProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_productKey);
  }
}
