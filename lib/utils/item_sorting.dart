import 'package:inventory_management/model/product.dart';

class ItemSorting {
  // Sort by name (alphabetically)
  List<Product> sortByName(List<Product> products, {bool ascending = true}) {
    products.sort((a, b) =>
        ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
    return products;
  }

  // Sort by SKU (alphabetically)
  List<Product> sortBySKU(List<Product> products, {bool ascending = true}) {
    products.sort(
        (a, b) => ascending ? a.sku.compareTo(b.sku) : b.sku.compareTo(a.sku));
    return products;
  }

  // Sort by quantity (numerically)
  List<Product> sortByQuantity(List<Product> products,
      {bool ascending = true}) {
    products.sort((a, b) => ascending
        ? a.quantity.compareTo(b.quantity)
        : b.quantity.compareTo(a.quantity));
    return products;
  }
}
