// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freeItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreeItem _$FreeItemFromJson(Map<String, dynamic> json) => FreeItem(
  (json['buy_qty'] as num).toInt(),
  (json['free_qty'] as num).toInt(),
  (json['free_sku_id'] as num).toInt(),
  json['free_sku_code'] as String,
  (json['stocks'] as List<dynamic>?)
      ?.map((e) => Warehouse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FreeItemToJson(FreeItem instance) => <String, dynamic>{
  'buy_qty': instance.buy_qty,
  'free_qty': instance.free_qty,
  'free_sku_id': instance.free_sku_id,
  'free_sku_code': instance.free_sku_code,
  'stocks': instance.stocks,
};
