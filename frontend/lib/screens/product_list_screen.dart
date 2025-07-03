import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product_provider.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    // Removed automatic fetch to avoid main thread overload; add manual refresh
  }

  void _onRefresh(ProductProvider provider) async {
    await provider.fetchProducts();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddProductScreen()),
            ),
          ),
        ],
      ),
      body: provider.isLoading && provider.products.isEmpty
          ? Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final provider = Provider.of<ProductProvider>(context, listen: false);
                      provider.fetchProducts();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : SmartRefresher(
              controller: _refreshController,
              onRefresh: () {
                final provider = Provider.of<ProductProvider>(context, listen: false);
                _onRefresh(provider);
              },
              child: ListView.builder(
                itemCount: provider.products.length,
                itemBuilder: (context, index) {
                  final product = provider.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Price: ${product.price}, Stock: ${product.stock}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditProductScreen(product: product)),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete ${product.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final provider = Provider.of<ProductProvider>(context, listen: false);
                                    provider.deleteProduct(product.id);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}