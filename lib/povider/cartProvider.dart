import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/shoping.dart';


class CartProvider with ChangeNotifier {
  final List<Shoping> _items = [];

  List<Shoping> get items => _items;

  void addItem(Shoping shoping) {
    // ✅ เช็กว่ามีสินค้านี้แล้วหรือยัง
    final index = _items.indexWhere((item) => item.name == shoping.name);
    if (index != -1) {
      _items[index].quantity++; // ถ้ามีแล้ว → qty +1
    } else {
      _items.add(shoping);
    }
    notifyListeners();
  }

  void removeItem(Shoping shoping) {
    _items.remove(shoping);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
