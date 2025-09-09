import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/service/productApi.dart';

class ProductController extends ChangeNotifier {
  ProductController({this.api = const ProductApi()});
  ProductApi api;

  List<ProductTyp> products = [];

  getproductlist() async {
    products.clear();
    products = await ProductApi.getproductlist();
    notifyListeners();
  }
}
