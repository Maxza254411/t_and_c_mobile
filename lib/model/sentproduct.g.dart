// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentproduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SentProduct _$SentProductFromJson(Map<String, dynamic> json) => SentProduct(
  json['product_id'] as String?,
  json['product_sku_id'] as String?,
  json['price'] as String?,
  json['warehouse_id'] as String?,
  json['qty'] as String?,
);

Map<String, dynamic> _$SentProductToJson(SentProduct instance) =>
    <String, dynamic>{
      'product_id': instance.product_id,
      'product_sku_id': instance.product_sku_id,
      'warehouse_id': instance.warehouse_id,
      'price': instance.price,
      'qty': instance.qty,
    };
