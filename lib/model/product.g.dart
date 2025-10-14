// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  json['product_id'] as String?,
  json['product_name'] as String?,
  json['product_sku'] as String?,
  json['product_sku_id'] as String?,
  json['price'] as String?,
  json['warehouse_id'] as String?,
  json['qty'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'product_id': instance.product_id,
  'product_name': instance.product_name,
  'product_sku': instance.product_sku,
  'product_sku_id': instance.product_sku_id,
  'warehouse_id': instance.warehouse_id,
  'price': instance.price,
  'qty': instance.qty,
};
