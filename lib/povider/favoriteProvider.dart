import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/shoping.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Shoping> _favorites = [];

  List<Shoping> get favorites => _favorites;

  void toggleFavorite(Shoping item) {
    final isExist = _favorites.any((fav) =>
        fav.name == item.name &&
        fav.color == item.color); // กันซ้ำชื่อ+สี

    if (isExist) {
      _favorites.removeWhere((fav) =>
          fav.name == item.name &&
          fav.color == item.color);
    } else {
      _favorites.add(item);
    }

    notifyListeners();
  }

  bool isFavorite(Shoping item) {
    return _favorites.any((fav) =>
        fav.name == item.name &&
        fav.color == item.color);
  }
}
