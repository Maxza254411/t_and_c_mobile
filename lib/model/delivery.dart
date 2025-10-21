import 'package:json_annotation/json_annotation.dart';

part 'delivery.g.dart';

@JsonSerializable()
class Delivery {
  int id;
  String? dn_code;
  int? quotation_id;
  int? distributor_id;
  int? warehouse_id;
  int? address_id;
  int? staff_id;
  String? ref_type;
  String? ref_code;
  String? payment_terms;
  String? delivery_date;
  String? status;
  String? payment_status;
  String? total_po_unit;
  String? total_demo_unit;
  String? total_po_cost_ex_vat;
  String? total_demo_cost_ex_vat;
  String? total_po_vat_amount;
  String? total_demo_vat_amount;
  String? total_po_cost_inc_vat;
  String? total_demo_cost_inc_vat;
  String? grand_total;
  String?status_name;


  Delivery(
    this.id,
    this.dn_code,
    this.quotation_id,
    this.distributor_id,
    this.warehouse_id,
    this.address_id,
    this.staff_id,
    this.ref_type,
    this.ref_code,
    this.payment_terms,
    this.delivery_date,
    this.status,
    this.payment_status,
    this.total_po_unit,
    this.total_demo_unit,
    this.total_po_cost_ex_vat,
    this.total_demo_cost_ex_vat,
    this.total_po_vat_amount,
    this.total_demo_vat_amount,
    this.total_po_cost_inc_vat,
    this.total_demo_cost_inc_vat,
    this.grand_total,
    this.status_name,
  );

  factory Delivery.fromJson(Map<String, dynamic> json) =>
      _$DeliveryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryToJson(this);
}
