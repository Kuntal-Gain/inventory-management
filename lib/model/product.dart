class Product {
  String name;
  String sku;
  double price;
  int quantity;

  Product({
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  // Convert a Product to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'price': price,
      'quantity': quantity,
    };
  }

  // Convert a Map to a Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      sku: json['sku'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}
