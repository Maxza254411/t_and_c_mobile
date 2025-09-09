// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) =>
    Data(
        (json['id'] as num).toInt(),
        json['sku'] as String?,
        json['barcode'] as String?,
        (json['product_id'] as num?)?.toInt(),
        (json['color_id'] as num?)?.toInt(),
        (json['status'] as num?)?.toInt(),
        json['cardType'] as String?,
        json['product'] == null
            ? null
            : ProductTyp.fromJson(json['product'] as Map<String, dynamic>),
      )
      ..color = json['color'] == null
          ? null
          : Colorp.fromJson(json['color'] as Map<String, dynamic>);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'id': instance.id,
  'sku': instance.sku,
  'barcode': instance.barcode,
  'product_id': instance.product_id,
  'color_id': instance.color_id,
  'status': instance.status,
  'cardType': instance.cardType,
  'product': instance.product,
  'color': instance.color,
};
