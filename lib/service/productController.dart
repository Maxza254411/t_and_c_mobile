import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/brands.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/service/productApi.dart';

class ProductController extends ChangeNotifier {
  ProductController({this.api = const ProductApi()});
  ProductApi api;

  List<ProductTyp> productTyp = [];
  List<Data>productbyid =[];
  List<Data>product =[];
  List<Brands>brands=[];
  List<ProductTyp>productBandTyp=[];

  getproductlist() async {
    productTyp.clear();
    productTyp = await ProductApi.getproductlist();
    notifyListeners();
  }
  getproductbyid({required int id,required int page }) async {
    productbyid.clear();
    productbyid = await ProductApi.getproductbyid(id: id,page: page);
    notifyListeners();
  }
  getproduct() async {
    product.clear();
    product = await ProductApi.getproduct();
    notifyListeners();
  }
  listbrands() async {
    brands.clear();
    brands = await ProductApi.listbrands();
    notifyListeners();
  }
   getproductypBybrandId({required int brandid}) async {
    productBandTyp.clear();
    productBandTyp = await ProductApi.getproductypBybrandid(brandid: brandid);
    notifyListeners();
  }
}
