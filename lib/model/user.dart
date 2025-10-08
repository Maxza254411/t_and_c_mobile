import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/customer.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
int id;
String? user_type;
String? first_name;
String? last_name;
String? nickname;
String? tel_no;
String? staff_code;
String? joined_date;
String? resigned_date;
String? name;
String? email;
String? email_verified_at;
int? status;
String? created_at;
String? created_by;
String? updated_at;
String? updated_by;
Customer? customer;

 

  User(this.id, this.user_type, this.first_name, this.last_name, this.nickname, this.tel_no, this.staff_code, this.joined_date, this.resigned_date, this.name, this.email, this.email_verified_at, this.status, this.created_at, this.created_by, this.updated_at, this.updated_by,);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}