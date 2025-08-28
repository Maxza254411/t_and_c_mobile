import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/service/productApi.dart';

class ProductController extends ChangeNotifier {
  ProductController({this.api = const ProductApi()});
  ProductApi api;}