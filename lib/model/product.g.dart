// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  json['product_id'] as String?,
  json['product_sku_id'] as String?,
  json['price'] as String?,
  json['warehouse_id'] as String?,
  json['qty'] as String?,
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'product_id': instance.product_id,
  'product_sku_id': instance.product_sku_id,
  'warehouse_id': instance.warehouse_id,
  'price': instance.price,
  'qty': instance.qty,
};
