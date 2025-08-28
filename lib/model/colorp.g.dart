// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colorp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Colorp _$ColorpFromJson(Map<String, dynamic> json) => Colorp(
  (json['id'] as num).toInt(),
  json['name_th'] as String?,
  json['name_en'] as String?,
  (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$ColorpToJson(Colorp instance) => <String, dynamic>{
  'id': instance.id,
  'name_th': instance.name_th,
  'name_en': instance.name_en,
  'status': instance.status,
};
