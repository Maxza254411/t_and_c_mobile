import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/shoping.dart';

class CartProvider with ChangeNotifier {
  int userId; // userId ของผู้ใช้ปัจจุบัน
  final List<Shoping> _items = [];

  CartProvider(this.userId);

  // แสดงสินค้าของผู้ใช้คนนี้เท่านั้น
  List<Shoping> get items => _items.where((item) => item.userId == userId).toList();

  // เพิ่มสินค้า
  void addItem(Shoping shoping) {
    shoping.userId = userId;

    // ตรวจสอบสินค้าที่ชื่อเหมือนและสีเหมือนกัน
    final index = _items.indexWhere((item) => item.userId == userId && item.name == shoping.name && item.color == shoping.color && item.isFree == shoping.isFree);

    if (index != -1) {
      // ถ้ามีสินค้าสีเดียวกันแล้ว เพิ่ม quantity
      _items[index].quantity += shoping.quantity;
    } else {
      // ถ้าไม่มีสินค้าสีเดียวกัน เพิ่มสินค้าใหม่
      _items.add(shoping);
    }

    notifyListeners();
  }

  // ลบสินค้า
  void removeItem(Shoping shoping) {
    _items.removeWhere((item) => item.name == shoping.name && item.color == shoping.color && item.userId == userId);
    notifyListeners();
  }

  // ลบสินค้าทั้งหมดของ user
  void clearCart() {
    _items.removeWhere((item) => item.userId == userId);
    notifyListeners();
  }

  // ลบสินค้าที่เลือก
  void removeSelected(List<Shoping> selectedItems) {
    for (final item in selectedItems) {
      _items.removeWhere((i) => i.name == item.name && i.color == item.color && i.userId == userId);
    }
    notifyListeners();
  }

  // -------------------------------
  // เพิ่มฟังก์ชันเพิ่มของแถม
  // -------------------------------
  void addFreeItem({required int quantity, required String skuCode, required String name}) {
    // ลบของแถมที่มี skuCode เดิมก่อน
    _items.removeWhere((item) => item.isFree! && item.sku_code == skuCode && item.userId == userId);

    // เพิ่มของแถมใหม่
    _items.add(
      Shoping(
        userId: userId,
        quantity: quantity,
        sku_code: skuCode,
        name: name,
        price_per_unit: 0, // ของแถมฟรี
        isFree: true,
        nameTh: '',
        price: '',
        warehouse_skus: [],
        newData: null, // ติด flag ว่าเป็นของแถม
      ),
    );

    notifyListeners();
  }
}
