import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/promotione.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';

part 'skus.g.dart';

@JsonSerializable()
class Skus {
  int id;
  int? product_sku_id;
  int? product_id;
  String? sku;
  int? color_id;
  int? status;
  String? path_image;
  String? image_url;
  int? base_price;
  List<Promotione>? promotions;
  Colorp? color;
  List<Warehouse>?warehouse_skus;


  Skus(
    this.id,
    this.product_sku_id,
    this.product_id,
    this.sku,
    this.color_id,
    this.status,
    this.path_image,
    this.image_url,
    this.base_price,
    this.promotions,
    this.color,
    this.warehouse_skus,
  );

  factory Skus.fromJson(Map<String, dynamic> json) => _$SkusFromJson(json);

  Map<String, dynamic> toJson() => _$SkusToJson(this);
}
