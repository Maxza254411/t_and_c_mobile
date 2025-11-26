import 'package:json_annotation/json_annotation.dart';

part 'warehouse.g.dart';

@JsonSerializable()
class Warehouse {
  int? id;
  int? warehouse_id;
  int? product_sku_id;
  int? amount;
  String? type;
  int? available;

  Warehouse(this.id, this.warehouse_id, this.product_sku_id, this.amount, this.type, this.available);

  factory Warehouse.fromJson(Map<String, dynamic> json) => _$WarehouseFromJson(json);

  Map<String, dynamic> toJson() => _$WarehouseToJson(this);
}
