// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brands.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Brands _$BrandsFromJson(Map<String, dynamic> json) => Brands(
  (json['id'] as num).toInt(),
  json['code'] as String?,
  json['name'] as String?,
  (json['status'] as num?)?.toInt(),
  json['image_url'] as String?,
  json['img_path'] as String?,
);

Map<String, dynamic> _$BrandsToJson(Brands instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'status': instance.status,
  'image_url': instance.image_url,
  'img_path': instance.img_path,
};
