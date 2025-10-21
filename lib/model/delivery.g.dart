// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Delivery _$DeliveryFromJson(Map<String, dynamic> json) => Delivery(
  (json['id'] as num).toInt(),
  json['dn_code'] as String?,
  (json['quotation_id'] as num?)?.toInt(),
  (json['distributor_id'] as num?)?.toInt(),
  (json['warehouse_id'] as num?)?.toInt(),
  (json['address_id'] as num?)?.toInt(),
  (json['staff_id'] as num?)?.toInt(),
  json['ref_type'] as String?,
  json['ref_code'] as String?,
  json['payment_terms'] as String?,
  json['delivery_date'] as String?,
  json['status'] as String?,
  json['payment_status'] as String?,
  json['total_po_unit'] as String?,
  json['total_demo_unit'] as String?,
  json['total_po_cost_ex_vat'] as String?,
  json['total_demo_cost_ex_vat'] as String?,
  json['total_po_vat_amount'] as String?,
  json['total_demo_vat_amount'] as String?,
  json['total_po_cost_inc_vat'] as String?,
  json['total_demo_cost_inc_vat'] as String?,
  json['grand_total'] as String?,
  json['status_name'] as String?,
);

Map<String, dynamic> _$DeliveryToJson(Delivery instance) => <String, dynamic>{
  'id': instance.id,
  'dn_code': instance.dn_code,
  'quotation_id': instance.quotation_id,
  'distributor_id': instance.distributor_id,
  'warehouse_id': instance.warehouse_id,
  'address_id': instance.address_id,
  'staff_id': instance.staff_id,
  'ref_type': instance.ref_type,
  'ref_code': instance.ref_code,
  'payment_terms': instance.payment_terms,
  'delivery_date': instance.delivery_date,
  'status': instance.status,
  'payment_status': instance.payment_status,
  'total_po_unit': instance.total_po_unit,
  'total_demo_unit': instance.total_demo_unit,
  'total_po_cost_ex_vat': instance.total_po_cost_ex_vat,
  'total_demo_cost_ex_vat': instance.total_demo_cost_ex_vat,
  'total_po_vat_amount': instance.total_po_vat_amount,
  'total_demo_vat_amount': instance.total_demo_vat_amount,
  'total_po_cost_inc_vat': instance.total_po_cost_inc_vat,
  'total_demo_cost_inc_vat': instance.total_demo_cost_inc_vat,
  'grand_total': instance.grand_total,
  'status_name': instance.status_name,
};
