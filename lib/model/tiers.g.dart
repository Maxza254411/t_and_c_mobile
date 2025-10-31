// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tiers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tiers _$TiersFromJson(Map<String, dynamic> json) => Tiers(
  (json['min_qty'] as num?)?.toInt(),
  (json['max_qty'] as num?)?.toInt(),
  (json['price_per_unit'] as num?)?.toInt(),
);

Map<String, dynamic> _$TiersToJson(Tiers instance) => <String, dynamic>{
  'min_qty': instance.min_qty,
  'max_qty': instance.max_qty,
  'price_per_unit': instance.price_per_unit,
};
