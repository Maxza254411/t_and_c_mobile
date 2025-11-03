import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/promotione.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';

part 'shoping.g.dart';

@JsonSerializable(explicitToJson: true)
class Shoping {
  String? product_id;
  String? image;
  final String name;
  final String nameTh;
  String? price;
  final String color;
  String? product_sku_id;
  String? warehouse_id;
  int quantity;
  int? userId;
  List<Colorp?>? colors;
  List<Data>? sameproduct;
  List<String?>? skulist;
  List<int>?skuidlist;
  String? qty;
  final List<Warehouse> warehouse_skus;
  String? namebrand;
  List<Promotione>? promotion;
  final String? sku;
  final int? skuid;
  int?price_per_unit;

  Shoping({
    required this.nameTh,
    this.skulist,
    this.skuidlist,
    this.warehouse_id,
    this.product_sku_id,
    this.image,
    this.product_id,
    required this.name,
    required this.price,
    required this.color,
    this.colors,
    this.quantity = 1,
    this.userId,
    this.sameproduct,
    this.qty,
    required this.warehouse_skus,
    this.namebrand,
    this.sku,
    this.skuid,
    this.promotion,
    this.price_per_unit,

  });

  factory Shoping.fromJson(Map<String, dynamic> json) =>
      _$ShopingFromJson(json);
  Map<String, dynamic> toJson() => _$ShopingToJson(this);
}
