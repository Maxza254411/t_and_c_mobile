import 'package:json_annotation/json_annotation.dart';

part 'sentproduct.g.dart';

@JsonSerializable()
class SentProduct {
  String? product_id;
  String? product_sku_id;
  String? warehouse_id;
  String? price;
  String? qty;

  SentProduct(this.product_id,this.product_sku_id,this.price,this.warehouse_id,this.qty);

  factory SentProduct.fromJson(Map<String, dynamic> json) =>
      _$SentProductFromJson(json);

  Map<String, dynamic> toJson() => _$SentProductToJson(this);
}
