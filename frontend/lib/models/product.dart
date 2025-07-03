class Product {
  final int id;
  String name;
  double price;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? json['PRODUCTID'],
      name: json['name'] ?? json['productName'] ?? json['PRODUCTNAME'],
      price: json['price'] is String
          ? double.parse(json['price'] ?? json['PRICE'] ?? '0.0')
          : (json['price'] ?? json['PRICE'] ?? 0.0).toDouble(),
      stock: json['stock'] is String
          ? int.parse(json['stock'] ?? json['STOCK'] ?? '0')
          : (json['stock'] ?? json['STOCK'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': name,
      'price': price,
      'stock': stock,
    };
  }
}