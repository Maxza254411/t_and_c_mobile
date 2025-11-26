import 'package:json_annotation/json_annotation.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';

part 'freeItem.g.dart';

@JsonSerializable()
class FreeItem {
  int? buy_qty;
  int? free_qty;
  int? free_sku_id;
  String? free_sku_code;
  String? free_product_name_en;
  String? free_sku_image_path;
  List<Warehouse>? stocks;

  FreeItem(this.buy_qty, this.free_qty, this.free_sku_id, this.free_sku_code, this.stocks, this.free_product_name_en, this.free_sku_image_path);

  factory FreeItem.fromJson(Map<String, dynamic> json) => _$FreeItemFromJson(json);

  Map<String, dynamic> toJson() => _$FreeItemToJson(this);
}
