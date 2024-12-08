import 'package:flutter/material.dart';

import '../model/product.dart';

void showProductPopup(BuildContext context, Function(Product) onSubmit) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController skuController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.orange,
        title: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextField(
                controller: skuController,
                decoration: const InputDecoration(
                  labelText: 'SKU',
                  hintText: 'Enter SKU',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Enter quantity',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  skuController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  quantityController.text.isNotEmpty) {
                // Create a Product instance from the input
                Product product = Product(
                  name: nameController.text,
                  sku: skuController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                );

                onSubmit(product); // Pass the Product instance to the callback
                Navigator.of(context).pop(); // Close the dialog
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill out all fields')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}

void updateProductPopUp(
    BuildContext context, Function(Product) onSubmit, Product product) {
  final TextEditingController nameController =
      TextEditingController(text: product.name);
  final TextEditingController skuController =
      TextEditingController(text: product.sku);
  final TextEditingController priceController =
      TextEditingController(text: product.price.toString());
  final TextEditingController quantityController =
      TextEditingController(text: product.quantity.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update Product'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                ),
              ),
              TextField(
                controller: skuController,
                decoration: const InputDecoration(
                  labelText: 'SKU',
                  hintText: 'Enter SKU',
                ),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price',
                ),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Enter quantity',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  skuController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  quantityController.text.isNotEmpty) {
                // Create a Product instance from the input
                Product product = Product(
                  name: nameController.text,
                  sku: skuController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  quantity: int.tryParse(quantityController.text) ?? 0,
                );

                onSubmit(product); // Pass the Product instance to the callback
                Navigator.of(context).pop(); // Close the dialog
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill out all fields')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}

Widget infoCard(String label, int value) {
  return Container(
    margin: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xffc2c2c2),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}

Widget controllerButton(Function() operation, String label) {
  Color color = Colors.transparent;

  switch (label.toLowerCase()) {
    case 'sell':
      color = Colors.red;
      break;
    case 'restock':
      color = Colors.green;
      break;
    case 'update':
      color = Colors.blue;
      break;
    default:
  }

  return GestureDetector(
    onTap: () => operation(),
    child: Container(
      height: 40,
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    ),
  );
}
