// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
  (json['id'] as num).toInt(),
  (json['user_id'] as num?)?.toInt(),
  json['company_code'] as String?,
  json['company_name'] as String?,
  (json['customer_type_id'] as num?)?.toInt(),
  json['customer_tier'] as String?,
  json['payment_term'] as String?,
  json['credit_limit'] as String?,
  json['current_credit_used'] as String?,
  json['contact_person'] as String?,
  json['contact_email'] as String?,
  json['contact_phone'] as String?,
  json['address'] as String?,
  json['tax_id'] as String?,
);

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.user_id,
  'company_code': instance.company_code,
  'company_name': instance.company_name,
  'customer_type_id': instance.customer_type_id,
  'customer_tier': instance.customer_tier,
  'payment_term': instance.payment_term,
  'credit_limit': instance.credit_limit,
  'current_credit_used': instance.current_credit_used,
  'contact_person': instance.contact_person,
  'contact_email': instance.contact_email,
  'contact_phone': instance.contact_phone,
  'address': instance.address,
  'tax_id': instance.tax_id,
};
