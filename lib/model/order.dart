import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class Order {
  int id;
  String? qo_code;
  String? distributor_id;
  String? image_url;
  String? qo_date;
  String? status;
  String? address_id;
  String? total_po_unit;
  String? total_po_cost_ex_vat;
  String? total_po_vat_amount;
  String? total_po_cost_inc_vat;
  String? grand_total;
  String? slip_path;
  String? updated_at;
  String? created_at;
  String? status_name;
  String? status_badge;
  String? stage;

  Order(
    this.id,
    this.qo_code,
    this.distributor_id,
    this.image_url,
    this.qo_date,
    this.status,
    this.address_id,
    this.total_po_unit,
    this.total_po_cost_ex_vat,
    this.total_po_vat_amount,
    this.total_po_cost_inc_vat,
    this.grand_total,
    this.slip_path,
    this.updated_at,
    this.created_at,
    this.status_name,
    this.status_badge,
    this.stage,
  );

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}
