import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/shoping.dart';


class CartProvider with ChangeNotifier {
  final int userId; // userId ของผู้ใช้ปัจจุบัน
  final List<Shoping> _items = [];

  CartProvider(this.userId);

  // แสดงสินค้าของผู้ใช้คนนี้เท่านั้น
  List<Shoping> get items =>
      _items.where((item) => item.userId == userId).toList();

  void addItem(Shoping shoping) {
    shoping.userId = userId; // กำหนด userId ให้กับสินค้า

    final index = _items.indexWhere(
        (item) => item.name == shoping.name && item.userId == userId);

    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(shoping);
    }
    notifyListeners();
  }

  void removeItem(Shoping shoping) {
    _items.removeWhere(
        (item) => item.name == shoping.name && item.userId == userId);
    notifyListeners();
  }

  void clearCart() {
    _items.removeWhere((item) => item.userId == userId);
    notifyListeners();
  }
}

