// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
  (json['id'] as num).toInt(),
  (json['subdistrict_id'] as num?)?.toInt(),
  json['address_line1'] as String?,
  (json['zipcode'] as num?)?.toInt(),
  (json['status'] as num?)?.toInt(),
  json['full_th_address'] as String?,
);

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'subdistrict_id': instance.subdistrict_id,
  'address_line1': instance.address_line1,
  'zipcode': instance.zipcode,
  'status': instance.status,
  'full_th_address': instance.full_th_address,
};
