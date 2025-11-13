import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/NewProductModel/skus.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/promotione.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';

part 'newdata.g.dart';

@JsonSerializable()
class Newdata {
   int id;
   int? product_id;
   String? name_th;
   String? name_en;
   int? brand_id;
   int? product_type_id;
   String? path_image;
   int? status;
   List<Skus>?skus; 

  Newdata(this.id, this.product_id, this.name_th, this.name_en, this.brand_id, this.product_type_id, this.path_image, this.status,this.skus);

  factory Newdata.fromJson(Map<String, dynamic> json) => _$NewdataFromJson(json);

  Map<String, dynamic> toJson() => _$NewdataToJson(this);
}
