import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/shoping.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Shoping> _favorites = [];

  List<Shoping> get favorites => _favorites;

  void toggleFavorite(Shoping item) {
    final isExist = _favorites.any((fav) => fav.productId == item.productId);

    if (isExist) {
      _favorites.removeWhere((fav) => fav.productId == item.productId);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }

  bool isFavorite(Shoping item) {
    return _favorites.any((fav) => fav.productId == item.productId);
  }
}

