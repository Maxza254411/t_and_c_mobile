// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distributors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Distributors _$DistributorsFromJson(Map<String, dynamic> json) => Distributors(
  (json['id'] as num).toInt(),
  json['user_id'] as String?,
  json['company_code'] as String?,
  json['company_name'] as String?,
  (json['customer_type_id'] as num?)?.toInt(),
  json['address'] as String?,
  json['customer_tier'] as String?,
  json['payment_term'] as String?,
  json['contact_person'] as String?,
  json['contact_email'] as String?,
  json['contact_phone'] as String?,
  json['tax_id'] as String?,
);

Map<String, dynamic> _$DistributorsToJson(Distributors instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'company_code': instance.company_code,
      'company_name': instance.company_name,
      'customer_type_id': instance.customer_type_id,
      'address': instance.address,
      'customer_tier': instance.customer_tier,
      'payment_term': instance.payment_term,
      'contact_person': instance.contact_person,
      'contact_email': instance.contact_email,
      'contact_phone': instance.contact_phone,
      'tax_id': instance.tax_id,
    };
