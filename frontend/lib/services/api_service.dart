import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // Emulator uses 10.0.2.2 for host

  static Future<List<Product>> fetchProducts() async {
    print('Fetching products from: $baseUrl/products');
    final response = await http.get(Uri.parse('$baseUrl/products'));
    print('Response status: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Product> addProduct(Product product) async {
    print('Adding product to: $baseUrl/products with data: ${json.encode(product.toJson()..remove('id'))}');
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()..remove('id')),
    );
    print('Response status: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 201) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add product: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<Product> updateProduct(Product product) async {
    print('Updating product at: $baseUrl/products/${product.id} with data: ${json.encode(product.toJson())}');
    final response = await http.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );
    print('Response status: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update product: ${response.statusCode} - ${response.body}');
    }
  }

  static Future<void> deleteProduct(int id) async {
    print('Deleting product at: $baseUrl/products/$id');
    final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
    print('Response status: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.statusCode} - ${response.body}');
    }
  }
}