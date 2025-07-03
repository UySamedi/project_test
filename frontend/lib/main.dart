import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_provider.dart';
import 'screens/product_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        title: 'Product CRUD',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ProductListScreen(),
      ),
    );
  }
}