// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shoping _$ShopingFromJson(Map<String, dynamic> json) => Shoping(
  nameTh: json['nameTh'] as String,
  image: json['image'] as String?,
  product_id: json['product_id'] as String?,
  name: json['name'] as String,
  price: json['price'] as String,
  detail: json['detail'] as String,
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
);

Map<String, dynamic> _$ShopingToJson(Shoping instance) => <String, dynamic>{
  'product_id': instance.product_id,
  'image': instance.image,
  'name': instance.name,
  'nameTh': instance.nameTh,
  'price': instance.price,
  'detail': instance.detail,
  'color': instance.color,
  'quantity': instance.quantity,
  'userId': instance.userId,
  'colors': instance.colors?.map((e) => e?.toJson()).toList(),
  'sameproduct': instance.sameproduct?.map((e) => e?.toJson()).toList(),
  'sku': instance.sku,
};
