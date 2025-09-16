import 'package:t_and_c_mobile/model/colorp.dart';

/// สำหรับเอาของใส่ตะกร้า
class Shoping {
  String? productId;
  final String name;
  final String price;
  final String detail;
  final String color;
  int quantity;
  int? userId;
  List<Colorp?>? colors;
  Shoping({
    this.productId,
    required this.name,
    required this.price,
    required this.detail,
    required this.color,
    this.colors,
    this.quantity = 1,
    this.userId,
  });
}
