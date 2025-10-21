// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quotation _$QuotationFromJson(Map<String, dynamic> json) => Quotation(
  (json['id'] as num).toInt(),
  json['qo_code'] as String?,
  json['distributor_id'] as String?,
  json['parent_id'] as String?,
  json['payment_status'] as String?,
  json['warehouse_id'] as String?,
  json['address_id'] as String?,
  json['staff_id'] as String?,
  json['ref_type'] as String?,
  json['qo_date'] as String?,
  json['payment_terms'] as String?,
  json['status'] as String?,
  json['total_po_unit'] as String?,
  json['total_demo_unit'] as String?,
  json['total_po_cost_ex_vat'] as String?,
  json['total_demo_cost_ex_vat'] as String?,
  json['total_po_vat_amount'] as String?,
  json['total_demo_vat_amount'] as String?,
  json['total_po_cost_inc_vat'] as String?,
  json['total_demo_cost_inc_vat'] as String?,
  json['grand_total'] as String?,
  json['remark'] as String?,
  json['is_print'] as String?,
  json['payment_method'] as String?,
  json['status_name'] as String?,
  json['distributor'] == null
      ? null
      : Distributors.fromJson(json['distributor'] as Map<String, dynamic>),
  (json['delivery_orders'] as List<dynamic>)
      .map((e) => Delivery.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['items'] as List<dynamic>)
      .map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuotationToJson(Quotation instance) => <String, dynamic>{
  'id': instance.id,
  'qo_code': instance.qo_code,
  'distributor_id': instance.distributor_id,
  'parent_id': instance.parent_id,
  'payment_status': instance.payment_status,
  'warehouse_id': instance.warehouse_id,
  'address_id': instance.address_id,
  'staff_id': instance.staff_id,
  'ref_type': instance.ref_type,
  'qo_date': instance.qo_date,
  'payment_terms': instance.payment_terms,
  'status': instance.status,
  'total_po_unit': instance.total_po_unit,
  'total_demo_unit': instance.total_demo_unit,
  'total_po_cost_ex_vat': instance.total_po_cost_ex_vat,
  'total_demo_cost_ex_vat': instance.total_demo_cost_ex_vat,
  'total_po_vat_amount': instance.total_po_vat_amount,
  'total_demo_vat_amount': instance.total_demo_vat_amount,
  'total_po_cost_inc_vat': instance.total_po_cost_inc_vat,
  'total_demo_cost_inc_vat': instance.total_demo_cost_inc_vat,
  'grand_total': instance.grand_total,
  'remark': instance.remark,
  'is_print': instance.is_print,
  'payment_method': instance.payment_method,
  'status_name': instance.status_name,
  'distributor': instance.distributor,
  'delivery_orders': instance.delivery_orders,
  'items': instance.items,
};
