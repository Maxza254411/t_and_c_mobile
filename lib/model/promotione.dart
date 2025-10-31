import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/tiers.dart';

part 'promotione.g.dart';

@JsonSerializable()
class Promotione {
int promotion_id;
String? promotion_name;
int? promotion_type;
String? by_type;
List<Tiers>tiers;
int? percent;
int? fixed_price;

  Promotione(
    this.promotion_id,
    this.promotion_name,
    this.promotion_type,
    this.by_type,
    this.percent,
    this.fixed_price, this.tiers,
  );

  factory Promotione.fromJson(Map<String, dynamic> json) =>
      _$PromotioneFromJson(json);
  Map<String, dynamic> toJson() => _$PromotioneToJson(this);
}
