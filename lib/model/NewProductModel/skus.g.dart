// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Skus _$SkusFromJson(Map<String, dynamic> json) => Skus(
  (json['id'] as num).toInt(),
  (json['product_sku_id'] as num?)?.toInt(),
  (json['product_id'] as num?)?.toInt(),
  json['sku'] as String?,
  (json['color_id'] as num?)?.toInt(),
  (json['status'] as num?)?.toInt(),
  json['path_image'] as String?,
  json['image_url'] as String?,
  (json['base_price'] as num?)?.toInt(),
  (json['promotions'] as List<dynamic>?)
      ?.map((e) => Promotione.fromJson(e as Map<String, dynamic>))
      .toList(),
  json['color'] == null
      ? null
      : Colorp.fromJson(json['color'] as Map<String, dynamic>),
  (json['warehouse_skus'] as List<dynamic>?)
      ?.map((e) => Warehouse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SkusToJson(Skus instance) => <String, dynamic>{
  'id': instance.id,
  'product_sku_id': instance.product_sku_id,
  'product_id': instance.product_id,
  'sku': instance.sku,
  'color_id': instance.color_id,
  'status': instance.status,
  'path_image': instance.path_image,
  'image_url': instance.image_url,
  'base_price': instance.base_price,
  'promotions': instance.promotions,
  'color': instance.color,
  'warehouse_skus': instance.warehouse_skus,
};
