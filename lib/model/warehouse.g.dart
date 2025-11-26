// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Warehouse _$WarehouseFromJson(Map<String, dynamic> json) => Warehouse(
  (json['id'] as num?)?.toInt(),
  (json['warehouse_id'] as num?)?.toInt(),
  (json['product_sku_id'] as num?)?.toInt(),
  (json['amount'] as num?)?.toInt(),
  json['type'] as String?,
  (json['available'] as num?)?.toInt(),
);

Map<String, dynamic> _$WarehouseToJson(Warehouse instance) => <String, dynamic>{
  'id': instance.id,
  'warehouse_id': instance.warehouse_id,
  'product_sku_id': instance.product_sku_id,
  'amount': instance.amount,
  'type': instance.type,
  'available': instance.available,
};
