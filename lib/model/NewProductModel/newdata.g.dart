// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'newdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Newdata _$NewdataFromJson(Map<String, dynamic> json) => Newdata(
  (json['id'] as num).toInt(),
  (json['product_id'] as num?)?.toInt(),
  json['name_th'] as String?,
  json['name_en'] as String?,
  (json['brand_id'] as num?)?.toInt(),
  (json['product_type_id'] as num?)?.toInt(),
  json['path_image'] as String?,
  (json['status'] as num?)?.toInt(),
  (json['skus'] as List<dynamic>?)
      ?.map((e) => Skus.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NewdataToJson(Newdata instance) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.product_id,
  'name_th': instance.name_th,
  'name_en': instance.name_en,
  'brand_id': instance.brand_id,
  'product_type_id': instance.product_type_id,
  'path_image': instance.path_image,
  'status': instance.status,
  'skus': instance.skus,
};
