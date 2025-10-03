// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  (json['id'] as num).toInt(),
  (json['quotation_id'] as num?)?.toInt(),
  (json['product_id'] as num?)?.toInt(),
  (json['product_sku_id'] as num?)?.toInt(),
  (json['warehouse_id'] as num?)?.toInt(),
  json['mat_code'] as String?,
  json['ean_code'] as String?,
  json['model_no'] as String?,
  json['description'] as String?,
  json['gp_percent'] as String?,
  json['cost_ex_vat'] as String?,
  json['srp_inc_vat'] as String?,
  json['po_unit'] as String?,
  json['total_po_cost_ex_vat'] as String?,
  json['total_po_cost_inc_vat'] as String?,
  json['product'] == null
      ? null
      : ProductTyp.fromJson(json['product'] as Map<String, dynamic>),
  json['product_sku'] == null
      ? null
      : Data.fromJson(json['product_sku'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'id': instance.id,
  'quotation_id': instance.quotation_id,
  'product_id': instance.product_id,
  'product_sku_id': instance.product_sku_id,
  'warehouse_id': instance.warehouse_id,
  'mat_code': instance.mat_code,
  'ean_code': instance.ean_code,
  'model_no': instance.model_no,
  'description': instance.description,
  'gp_percent': instance.gp_percent,
  'cost_ex_vat': instance.cost_ex_vat,
  'srp_inc_vat': instance.srp_inc_vat,
  'po_unit': instance.po_unit,
  'total_po_cost_ex_vat': instance.total_po_cost_ex_vat,
  'total_po_cost_inc_vat': instance.total_po_cost_inc_vat,
  'product': instance.product,
  'product_sku': instance.product_sku,
};
