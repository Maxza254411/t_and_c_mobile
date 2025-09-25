import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';

/// สำหรับเอาของใส่ตะกร้า
class Shoping {
  String? productId;
  String? image;
  final String name;
  final String nameTh;
  final String price;
  final String detail;
  final String color;
  int quantity;
  int? userId;
  List<Colorp?>? colors;
  List<ProductTyp?>?sameproduct;
  String? sku;
  
  Shoping({
    required this.nameTh,
    this.image,
    this.productId,
    required this.name,
    required this.price,
    required this.detail,
    required this.color,
    this.colors,
    this.quantity = 1,
    this.userId,
    this.sameproduct,
    this.sku,
  });
}
