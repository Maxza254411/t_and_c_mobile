import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  int id;
  int? subdistrict_id;
  String? address_line1;
  int? zipcode;
  int? status;
  String? full_th_address;

  Address(
    this.id,
    this.subdistrict_id,
    this.address_line1,
    this.zipcode,
    this.status,
    this.full_th_address,
  );

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
