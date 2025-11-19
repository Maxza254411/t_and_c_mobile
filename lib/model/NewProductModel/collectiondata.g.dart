// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collectiondata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Collectiondata _$CollectiondataFromJson(Map<String, dynamic> json) =>
    Collectiondata(
      (json['id'] as num).toInt(),
      json['name'] as String?,
      (json['products'] as List<dynamic>?)
          ?.map((e) => Newdata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CollectiondataToJson(Collectiondata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'products': instance.products,
    };
