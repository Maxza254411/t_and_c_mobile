import 'package:json_annotation/json_annotation.dart';

part 'distributors.g.dart';

@JsonSerializable()
class Distributors {
 int id;
 int? user_id;
 String? company_code;
 String? company_name;
 int? customer_type_id;
 String? address;
 String? customer_tier;
 String? payment_term;
 String? contact_person;
 String? contact_email;
 String? contact_phone;
 String? tax_id;
Distributors(this.id, this.user_id, this.company_code, this.company_name, this.customer_type_id, this.address, this.customer_tier, this.payment_term, this.contact_person, this.contact_email, this.contact_phone, this.tax_id, );

  factory Distributors.fromJson(Map<String, dynamic> json) => _$DistributorsFromJson(json);

  Map<String, dynamic> toJson() => _$DistributorsToJson(this);
}