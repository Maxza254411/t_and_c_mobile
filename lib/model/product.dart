import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int id;
  String? name_th;
  String? name_en;
  String? short_code;
  String? full_code;
  String? factory_code;
  int? product_type_id;
  int? brand_id;
  String? description;
  String? srp_inc_vat;
  String? demo_srp_inc_vat;
  int? status;
  String? image_url;

  Product(
    this.id,
    this.name_th,
    this.name_en,
    this.short_code,
    this.full_code,
    this.factory_code,
    this.product_type_id,
    this.brand_id,
    this.description,
    this.srp_inc_vat,
    this.demo_srp_inc_vat,
    this.status,
    this.image_url,
  );

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
