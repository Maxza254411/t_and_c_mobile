import 'package:json_annotation/json_annotation.dart';

part 'productTyp.g.dart';

@JsonSerializable()
class ProductTyp {
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

  ProductTyp(
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

  factory ProductTyp.fromJson(Map<String, dynamic> json) =>
      _$ProductTypFromJson(json);

  Map<String, dynamic> toJson() => _$ProductTypToJson(this);
}
