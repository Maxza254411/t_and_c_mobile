import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';

part 'tiers.g.dart';

@JsonSerializable()
class Tiers {
  int? min_qty;
  int? max_qty;
  int? price_per_unit;

  Tiers(this.min_qty, this.max_qty, this.price_per_unit);

  factory Tiers.fromJson(Map<String, dynamic> json) => _$TiersFromJson(json);
  Map<String, dynamic> toJson() => _$TiersToJson(this);
}
