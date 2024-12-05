import 'package:flutter/material.dart';
import 'package:inventory_management/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:inventory_management/providers/product_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
