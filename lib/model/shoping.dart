import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';

part 'shoping.g.dart';

@JsonSerializable(explicitToJson: true)
class Shoping {
  String? product_id;
  String? image;
  final String name;
  final String nameTh;
  final String price;
  final String detail;
  final String color;
  String? product_sku_id;
  String?warehouse_id;
  int quantity;
  int? userId;
  List<Colorp?>? colors;
  List<ProductTyp?>? sameproduct;
  String? sku;
  String?qty;
final List<Warehouse>warehouse_skus;

  Shoping({
    required this.nameTh,
    this.warehouse_id,
    this.product_sku_id,
    this.image,
    this.product_id,
    required this.name,
    required this.price,
    required this.detail,
    required this.color,
    this.colors,
    this.quantity = 1,
    this.userId,
    this.sameproduct,
    this.sku,
    this.qty,
    required this.warehouse_skus,
  });

  factory Shoping.fromJson(Map<String, dynamic> json) => _$ShopingFromJson(json);
  Map<String, dynamic> toJson() => _$ShopingToJson(this);
}
