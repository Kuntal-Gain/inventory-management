import 'package:flutter/material.dart';
import 'package:inventory_management/widgets/inventory_card.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  double _previousTotalExpense = 0.0;
  double _previousTotalSales = 0.0;
  double _previousTotalProfit = 0.0;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.items;

    // Calculate current stats
    final totalProducts = products.length;
    final totalExpense = products.fold<double>(
        0.0, (sum, product) => sum + (product.price * product.quantity));
    final totalSales =
        products.fold<int>(0, (sum, product) => sum + product.quantity);
    final totalProfit = totalSales * 100.0 - totalExpense;

    // Calculate gain values (percentage change compared to previous values)
    final expenseGainValue = _calculatePercentageChange(
        previous: _previousTotalExpense, current: totalExpense);
    final salesGainValue = _calculatePercentageChange(
        previous: _previousTotalSales, current: totalSales.toDouble());
    final profitGainValue = _calculatePercentageChange(
        previous: _previousTotalProfit, current: totalProfit);

    // Update previous values for the next calculation
    _previousTotalExpense = totalExpense;
    _previousTotalSales = totalSales.toDouble();
    _previousTotalProfit = totalProfit;

    return Scaffold(
      backgroundColor: const Color(0xffEBE8ED),
      appBar: AppBar(
        toolbarHeight: 75,
        leading: const CircleAvatar(
          child: Icon(Icons.shopping_bag),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Welcome Back! 👋',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xffc2c2c2),
              ),
            ),
            Text(
              'My Shop',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              height: 200,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange,
                    Colors.orange.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.orange.shade300,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 4))
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "\$ ${totalProfit.toStringAsFixed(2)}", // Show dynamic total profit
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Total Net Profit", // Show dynamic total profit
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                inventoryCard(
                  icon: Icons.widgets,
                  label: "Total Products",
                  value: totalProducts,
                  gainValue: 0, // Static for products (or you can add logic)
                  isMoney: false,
                ),
                inventoryCard(
                  icon: Icons.monetization_on,
                  label: "Total Expense",
                  value: totalExpense,
                  gainValue: expenseGainValue,
                  isMoney: true,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                inventoryCard(
                  icon: Icons.shopping_basket,
                  label: "Total Sales",
                  value: totalSales,
                  gainValue: salesGainValue,
                  isMoney: false,
                ),
                inventoryCard(
                  icon: Icons.moving_outlined,
                  label: "Total Profit",
                  value: totalProfit,
                  gainValue: profitGainValue,
                  isMoney: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to calculate percentage change
  double _calculatePercentageChange(
      {required double previous, required double current}) {
    if (previous == 0) return 0; // Avoid division by zero
    return ((current - previous) / previous) * 100;
  }
}
