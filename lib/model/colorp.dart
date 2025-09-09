import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';

part 'colorp.g.dart';

@JsonSerializable()
class Colorp {
  int id;
  String? name_th;
  String? name_en;
  int? status;

  Colorp(this.id, this.name_th, this.name_en, this.status);

  factory Colorp.fromJson(Map<String, dynamic> json) => _$ColorpFromJson(json);

  Map<String, dynamic> toJson() => _$ColorpToJson(this);
}
