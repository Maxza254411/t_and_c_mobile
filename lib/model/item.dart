import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int id;
  int? quotation_id;
  int? product_id;
  int? product_sku_id;
  int? warehouse_id;
  String? mat_code;
  String? ean_code;
  String? model_no;
  String? description;
  String? gp_percent;
  String? cost_ex_vat;
  String? srp_inc_vat;
  String? po_unit;
  String? total_po_cost_ex_vat;
  String? total_po_cost_inc_vat;
  String?path_image;
  ProductTyp?product;
  
  Data?product_sku;

  Item(
    this.id,
    this.quotation_id,
    this.product_id,
    this.product_sku_id,
    this.warehouse_id,
    this.mat_code,
    this.ean_code,
    this.model_no,
    this.description,
    this.gp_percent,
    this.cost_ex_vat,
    this.srp_inc_vat,
    this.po_unit,
    this.total_po_cost_ex_vat,
    this.total_po_cost_inc_vat,
    this.product,
    this.product_sku,
    this.path_image,
  );

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
