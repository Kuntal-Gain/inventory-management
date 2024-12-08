import 'package:flutter/material.dart';
import 'package:inventory_management/screens/home_screen.dart';
import 'package:inventory_management/screens/stats_screen.dart';
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
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _screens = [
    StatsScreen(),
    ProductScreen(),
  ];

  int currentIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[currentIdx],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: "Products",
          ),
        ],
        onTap: (val) {
          setState(() {
            currentIdx = val;
          });
        },
      ),
    );
  }
}
