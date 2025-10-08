// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) =>
    User(
        (json['id'] as num).toInt(),
        json['user_type'] as String?,
        json['first_name'] as String?,
        json['last_name'] as String?,
        json['nickname'] as String?,
        json['tel_no'] as String?,
        json['staff_code'] as String?,
        json['joined_date'] as String?,
        json['resigned_date'] as String?,
        json['name'] as String?,
        json['email'] as String?,
        json['email_verified_at'] as String?,
        (json['status'] as num?)?.toInt(),
        json['created_at'] as String?,
        json['created_by'] as String?,
        json['updated_at'] as String?,
        json['updated_by'] as String?,
      )
      ..customer = json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'user_type': instance.user_type,
  'first_name': instance.first_name,
  'last_name': instance.last_name,
  'nickname': instance.nickname,
  'tel_no': instance.tel_no,
  'staff_code': instance.staff_code,
  'joined_date': instance.joined_date,
  'resigned_date': instance.resigned_date,
  'name': instance.name,
  'email': instance.email,
  'email_verified_at': instance.email_verified_at,
  'status': instance.status,
  'created_at': instance.created_at,
  'created_by': instance.created_by,
  'updated_at': instance.updated_at,
  'updated_by': instance.updated_by,
  'customer': instance.customer,
};
