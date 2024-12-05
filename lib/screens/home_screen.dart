import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/utils/item_sorting.dart';
import 'package:inventory_management/widgets/custom_widget.dart';
import 'package:inventory_management/providers/product_provider.dart';
import 'package:inventory_management/model/product.dart';
import 'package:provider/provider.dart'; // Import provider package

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> items = [];
  List<String> expandedItems = [];
  List<Product> filterItems = [];
  bool isSearchBarOpen = false;
  String query = "";

  List methods = [];
  int methodIdx = 0;
  List<String> names = ["Name", "SKU", "Quantity"];

  @override
  void initState() {
    super.initState();
    methods = [
      ItemSorting().sortByName(items),
      ItemSorting().sortBySKU(items),
      ItemSorting().sortByQuantity(items),
    ];
  }

  List<Product> _filterItems(List<Product> items) {
    if (query.isEmpty) return items;
    return items
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.sku.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Product> _sortItems(List<Product> items) {
    switch (methodIdx) {
      case 0:
        return ItemSorting().sortByName(items);
      case 1:
        return ItemSorting().sortBySKU(items);
      case 2:
        return ItemSorting().sortByQuantity(items);
      default:
        return items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Inventory'),
        actions: [
          IconButton(
              onPressed: () {
                showProductPopup(context, (data) {
                  context.read<ProductProvider>().addProduct(data);
                });
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  isSearchBarOpen = !isSearchBarOpen;
                });
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          // Dynamically sort items based on the selected method
          // List<Product> filterItems = _filterItems(provider.items);
          List<Product> filterItems = _sortItems(_filterItems(provider.items));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSearchBarOpen)
                Container(
                  height: 60,
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffc2c2c2),
                        spreadRadius: 2,
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) {
                      setState(() {
                        query = val; // Update the query dynamically
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Product by name or SKU',
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  infoCard("Total Products", provider.items.length),
                  infoCard("Stocks in Hand", totalProducts(provider.items)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Products List",
                      style: TextStyle(
                        color: Color(0xffc2c2c2),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // Cycle through sorting methods
                        methodIdx = (methodIdx + 1) % 3;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        'https://cdn-icons-png.flaticon.com/512/7043/7043943.png',
                        height: 40,
                        width: 40,
                        color: const Color(0xffc2c2c2),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filterItems.length,
                  itemBuilder: (context, idx) {
                    final product = filterItems[idx];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: productCard(context, product, provider),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int totalProducts(List<Product> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  Widget productCard(
      BuildContext context, Product product, ProductProvider provider) {
    final isExpanded = provider.isProductExpanded(product.sku);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (product.quantity <= 5)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Text(
                                'Low Stock',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    Text('${product.quantity} stocks left')
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                provider
                    .toggleProductExpansion(product.sku); // Toggle expansion
              },
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.arrow_forward_ios,
                size: !isExpanded ? 25 : 40,
              ),
            ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 500), // Slower animation
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter, // Animate from top to bottom
          child: isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10), // Add spacing for better UI
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BarcodeWidget(
                              data: 'product.sku',
                              barcode: Barcode.code128(),
                              height: 80,
                              width: 150,
                              drawText: false,
                            ),
                            Text(
                              product.sku.split('').join(' '),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Price per unit :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xffc2c2c2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '\$${product.price}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Price :',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xffc2c2c2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '\$${product.price * product.quantity}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        controllerButton(() {
                          provider.sellProduct(product); // Sell product
                        }, "Sell"),
                        controllerButton(() {
                          provider.restockProduct(product); // Restock product
                        }, "Restock"),
                        controllerButton(() {
                          updateProductPopUp(context, (data) {
                            provider.updateProduct(data); // Update product
                          }, product);
                        }, "Update"),
                        IconButton(
                          onPressed: () {
                            provider.removeProduct(product); // Remove product
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
