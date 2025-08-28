import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/product.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  int id;
  String? sku;
  String? barcode;
  int? product_id;
  int? color_id;
  int? status;
  String? cardType;
  Product?product;
  Colorp?color;

  Data(
    this.id,
    this.sku,
    this.barcode,
    this.product_id,
    this.color_id,
    this.status,
    this.cardType,
    this.product
  );

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
