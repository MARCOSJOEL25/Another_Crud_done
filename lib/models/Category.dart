// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

import 'package:another_crud/models/product.dart';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

class Category {
  Category({
    required this.id,
    required this.name,
    required this.products,
  });

  int id;
  String name;
  List<Product> products;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );
}
