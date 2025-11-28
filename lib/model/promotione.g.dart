// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotione.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Promotione _$PromotioneFromJson(Map<String, dynamic> json) => Promotione(
  (json['promotion_id'] as num).toInt(),
  json['promotion_name'] as String?,
  (json['promotion_type'] as num?)?.toInt(),
  json['by_type'] as String?,
  (json['percent'] as num?)?.toInt(),
  (json['fixed_price'] as num?)?.toInt(),
  (json['tiers'] as List<dynamic>)
      .map((e) => Tiers.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['free_item_rules'] as List<dynamic>?)
      ?.map((e) => FreeItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PromotioneToJson(Promotione instance) =>
    <String, dynamic>{
      'promotion_id': instance.promotion_id,
      'promotion_name': instance.promotion_name,
      'promotion_type': instance.promotion_type,
      'by_type': instance.by_type,
      'tiers': instance.tiers,
      'percent': instance.percent,
      'fixed_price': instance.fixed_price,
      'free_item_rules': instance.free_item_rules,
    };
