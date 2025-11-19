import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/NewProductModel/newdata.dart';
import 'package:t_and_c_mobile/model/NewProductModel/skus.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/promotione.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';

part 'collectiondata.g.dart';

@JsonSerializable()
class Collectiondata {
   int id;
   String? name;
   List<Newdata>?products;
  

  Collectiondata(this.id,this.name,this.products);

  factory Collectiondata.fromJson(Map<String, dynamic> json) => _$CollectiondataFromJson(json);

  Map<String, dynamic> toJson() => _$CollectiondataToJson(this);
}
