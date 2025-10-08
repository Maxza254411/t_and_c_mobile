import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
int id;
int? user_id;
String? company_code;
String? company_name;
int? customer_type_id;
String?customer_tier;
String?payment_term;
String? credit_limit;
String? current_credit_used;
String? contact_person;
String? contact_email;
String? contact_phone;
String? address;
String? tax_id;




  Customer(this.id, this.user_id, this.company_code, this.company_name, this.customer_type_id, this.customer_tier, this.payment_term, this.credit_limit, this.current_credit_used, this.contact_person, this.contact_email, this.contact_phone, this.address, this.tax_id, );

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}