// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  (json['id'] as num).toInt(),
  json['name_th'] as String?,
  json['name_en'] as String?,
  json['short_code'] as String?,
  json['full_code'] as String?,
  json['factory_code'] as String?,
  (json['product_type_id'] as num?)?.toInt(),
  (json['brand_id'] as num?)?.toInt(),
  json['description'] as String?,
  json['srp_inc_vat'] as String?,
  json['demo_srp_inc_vat'] as String?,
  (json['status'] as num?)?.toInt(),
  json['image_url'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'name_th': instance.name_th,
  'name_en': instance.name_en,
  'short_code': instance.short_code,
  'full_code': instance.full_code,
  'factory_code': instance.factory_code,
  'product_type_id': instance.product_type_id,
  'brand_id': instance.brand_id,
  'description': instance.description,
  'srp_inc_vat': instance.srp_inc_vat,
  'demo_srp_inc_vat': instance.demo_srp_inc_vat,
  'status': instance.status,
  'image_url': instance.image_url,
};
