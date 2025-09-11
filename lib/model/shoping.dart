/// สำหรับเอาของใส่ตะกร้า
class Shoping {
  final String name;
  final String price;
  final String detail;
  final String color;
  int quantity;

  Shoping({
    required this.name,
    required this.price,
    required this.detail,
    required this.color,
    this.quantity = 1,
  });
}
