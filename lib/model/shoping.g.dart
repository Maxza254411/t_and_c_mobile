// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shoping _$ShopingFromJson(Map<String, dynamic> json) => Shoping(
  nameTh: json['nameTh'] as String,
  skulist: (json['skulist'] as List<dynamic>?)
      ?.map((e) => e as String?)
      .toList(),
  skuidlist: (json['skuidlist'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
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
      ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
      .toList(),
  qty: json['qty'] as String?,
  warehouse_skus: (json['warehouse_skus'] as List<dynamic>)
      .map((e) => Warehouse.fromJson(e as Map<String, dynamic>))
      .toList(),
  namebrand: json['namebrand'] as String?,
  sku: json['sku'] as String?,
  skuid: (json['skuid'] as num?)?.toInt(),
  promotion: (json['promotion'] as List<dynamic>?)
      ?.map((e) => Promotione.fromJson(e as Map<String, dynamic>))
      .toList(),
  price_per_unit: (json['price_per_unit'] as num?)?.toInt(),
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
  'sameproduct': instance.sameproduct?.map((e) => e.toJson()).toList(),
  'skulist': instance.skulist,
  'skuidlist': instance.skuidlist,
  'qty': instance.qty,
  'warehouse_skus': instance.warehouse_skus.map((e) => e.toJson()).toList(),
  'namebrand': instance.namebrand,
  'promotion': instance.promotion?.map((e) => e.toJson()).toList(),
  'sku': instance.sku,
  'skuid': instance.skuid,
  'price_per_unit': instance.price_per_unit,
};
