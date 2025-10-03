// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  (json['id'] as num?)?.toInt(),
  json['qo_code'] as String?,
  (json['distributor_id'] as num?)?.toInt(),
  json['image_url'] as String?,
  json['qo_date'] as String?,
  json['status'] as String?,
  (json['address_id'] as num?)?.toInt(),
  json['total_po_unit'] as String?,
  json['total_po_cost_ex_vat'] as String?,
  json['total_po_vat_amount'] as String?,
  json['total_po_cost_inc_vat'] as String?,
  json['grand_total'] as String?,
  json['slip_path'] as String?,
  json['updated_at'] as String?,
  json['created_at'] as String?,
  json['status_name'] as String?,
  json['status_badge'] as String?,
  json['stage'] as String?,
  json['payment_method'] as String?,
  json['distributor'] == null
      ? null
      : Distributors.fromJson(json['distributor'] as Map<String, dynamic>),
  (json['items'] as List<dynamic>?)
      ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'qo_code': instance.qo_code,
  'distributor_id': instance.distributor_id,
  'image_url': instance.image_url,
  'qo_date': instance.qo_date,
  'status': instance.status,
  'address_id': instance.address_id,
  'total_po_unit': instance.total_po_unit,
  'total_po_cost_ex_vat': instance.total_po_cost_ex_vat,
  'total_po_vat_amount': instance.total_po_vat_amount,
  'total_po_cost_inc_vat': instance.total_po_cost_inc_vat,
  'grand_total': instance.grand_total,
  'slip_path': instance.slip_path,
  'updated_at': instance.updated_at,
  'created_at': instance.created_at,
  'status_name': instance.status_name,
  'status_badge': instance.status_badge,
  'stage': instance.stage,
  'payment_method': instance.payment_method,
  'distributor': instance.distributor,
  'items': instance.items,
};
