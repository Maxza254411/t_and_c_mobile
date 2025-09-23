import 'package:json_annotation/json_annotation.dart';

part 'brands.g.dart';

@JsonSerializable()
class Brands {
  int id;
  String? code;
  String? name;
  int? status;
  String?image_url;

  Brands(this.id, this.code, this.name, this.status,this.image_url);

  factory Brands.fromJson(Map<String, dynamic> json) => _$BrandsFromJson(json);

  Map<String, dynamic> toJson() => _$BrandsToJson(this);
}