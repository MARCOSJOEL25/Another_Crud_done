// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

class Product {
  Product({
    required this.productId,
    required this.productName,
    required this.description,
    required this.price,
    required this.location,
    required this.categoryId,
  });

  int productId;
  String productName;
  String description;
  double price;
  String location;
  int categoryId;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json["productId"],
        productName: json["productName"],
        description: json["description"],
        price: json["price"].toDouble(),
        location: json["location"],
        categoryId: json["categoryId"],
      );
}
