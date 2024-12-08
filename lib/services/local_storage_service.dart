import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_management/model/product.dart';

class LocalStorageService {
  static const String _productKey = 'productList';
  static const String _salesKey = 'salesTracking';
  static const String _restockKey = 'restockTracking';

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

  // Save sales tracking data
  static Future<void> saveSalesTracking(Map<String, int> sales) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_salesKey, jsonEncode(sales));
  }

  // Save restock tracking data
  static Future<void> saveRestockTracking(Map<String, int> restocks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_restockKey, jsonEncode(restocks));
  }

  // Get sales tracking data
  static Future<Map<String, int>> getSalesTracking() async {
    final prefs = await SharedPreferences.getInstance();
    final salesString = prefs.getString(_salesKey);
    if (salesString == null) return {};

    final Map<String, dynamic> salesJson = jsonDecode(salesString);
    return salesJson.map((key, value) => MapEntry(key, value as int));
  }

  // Get restock tracking data
  static Future<Map<String, int>> getRestockTracking() async {
    final prefs = await SharedPreferences.getInstance();
    final restockString = prefs.getString(_restockKey);
    if (restockString == null) return {};

    final Map<String, dynamic> restockJson = jsonDecode(restockString);
    return restockJson.map((key, value) => MapEntry(key, value as int));
  }

  // Remove all tracking data
  static Future<void> clearTrackingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_salesKey);
    await prefs.remove(_restockKey);
  }

  // Calculate total sales = (sold quantity * price)
  static double calculateTotalSales(
      List<Product> products, Map<String, int> sales) {
    return sales.entries.fold(0.0, (sum, entry) {
      final product = products.firstWhere((p) => p.sku == entry.key);
      return product != null ? sum + (entry.value * product.price) : sum;
    });
  }

  // Calculate total expense = (restocked quantity * price)
  static double calculateTotalExpense(
      List<Product> products, Map<String, int> restocks) {
    return restocks.entries.fold(0.0, (sum, entry) {
      final product = products.firstWhere((p) => p.sku == entry.key);
      return product != null ? sum + (entry.value * product.price) : sum;
    });
  }

  // Calculate net profit = total sales - total expense
  static double calculateNetProfit(List<Product> products,
      Map<String, int> sales, Map<String, int> restocks) {
    double totalSales = calculateTotalSales(products, sales);
    double totalExpense = calculateTotalExpense(products, restocks);
    return totalSales - totalExpense;
  }
}
