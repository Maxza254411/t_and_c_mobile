// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shoping _$ShopingFromJson(Map<String, dynamic> json) => Shoping(
  nameTh: json['nameTh'] as String,
  skulist: json['skulist'] == null
      ? null
      : Data.fromJson(json['skulist'] as Map<String, dynamic>),
  warehouse_id: json['warehouse_id'] as String?,
  product_sku_id: json['product_sku_id'] as String?,
  image: json['image'] as String?,
  product_id: json['product_id'] as String?,
  name: json['name'] as String,
  price: json['price'] as String,
  color: json['color'] as String,
  colors: (json['colors'] as List<dynamic>?)
      ?.map(
        (e) => e == null ? null : Colorp.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  quantity: (json['quantity'] as num?)?.toInt() ?? 1,
  userId: (json['userId'] as num?)?.toInt(),
  sameproduct: (json['sameproduct'] as List<dynamic>?)
      ?.map(
        (e) =>
            e == null ? null : ProductTyp.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  sku: json['sku'] as String?,
  qty: json['qty'] as String?,
  warehouse_skus: (json['warehouse_skus'] as List<dynamic>)
      .map((e) => Warehouse.fromJson(e as Map<String, dynamic>))
      .toList(),
  namebrand: json['namebrand'] as String?,
);

Map<String, dynamic> _$ShopingToJson(Shoping instance) => <String, dynamic>{
  'product_id': instance.product_id,
  'image': instance.image,
  'name': instance.name,
  'nameTh': instance.nameTh,
  'price': instance.price,
  'color': instance.color,
  'product_sku_id': instance.product_sku_id,
  'warehouse_id': instance.warehouse_id,
  'quantity': instance.quantity,
  'userId': instance.userId,
  'colors': instance.colors?.map((e) => e?.toJson()).toList(),
  'sameproduct': instance.sameproduct?.map((e) => e?.toJson()).toList(),
  'skulist': instance.skulist?.toJson(),
  'sku': instance.sku,
  'qty': instance.qty,
  'warehouse_skus': instance.warehouse_skus.map((e) => e.toJson()).toList(),
  'namebrand': instance.namebrand,
};
