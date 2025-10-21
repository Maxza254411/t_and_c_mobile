import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/delivery.dart';
import 'package:t_and_c_mobile/model/distributors.dart';
import 'package:t_and_c_mobile/model/item.dart';

part 'quotation.g.dart';

@JsonSerializable()
class Quotation {
  int id;
  String? qo_code;
  String? distributor_id;
  String? parent_id;
  String? payment_status;
  String? warehouse_id;
  String? address_id;
  String? staff_id;
  String? ref_type;
  String? qo_date;
  String? payment_terms;
  String? status;
  String? total_po_unit;
  String? total_demo_unit;
  String? total_po_cost_ex_vat;
  String? total_demo_cost_ex_vat;
  String? total_po_vat_amount;
  String? total_demo_vat_amount;
  String? total_po_cost_inc_vat;
  String? total_demo_cost_inc_vat;
  String? grand_total;
  String? remark;
  String? is_print;
  String? payment_method;
  String? status_name;
  Distributors? distributor;
  List<Delivery> delivery_orders;
  List<Item> items;

  Quotation(
    this.id,
    this.qo_code,
    this.distributor_id,
    this.parent_id,
    this.payment_status,
    this.warehouse_id,
    this.address_id,
    this.staff_id,
    this.ref_type,
    this.qo_date,
    this.payment_terms,
    this.status,
    this.total_po_unit,
    this.total_demo_unit,
    this.total_po_cost_ex_vat,
    this.total_demo_cost_ex_vat,
    this.total_po_vat_amount,
    this.total_demo_vat_amount,
    this.total_po_cost_inc_vat,
    this.total_demo_cost_inc_vat,
    this.grand_total,
    this.remark,
    this.is_print,
    this.payment_method,
    this.status_name,
    this.distributor,
    this.delivery_orders,
    this.items,
  );

  factory Quotation.fromJson(Map<String, dynamic> json) =>
      _$QuotationFromJson(json);

  Map<String, dynamic> toJson() => _$QuotationToJson(this);
}
