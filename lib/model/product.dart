import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  String? product_id;
  String? product_sku_id;
  String? warehouse_id;
  String? price;
  String? qty;

  Product(
    this.product_id,
    this.product_sku_id,
    this.price,
    this.warehouse_id,
    this.qty,
  );

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
