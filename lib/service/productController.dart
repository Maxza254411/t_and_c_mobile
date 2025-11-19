import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/model/NewProductModel/collectiondata.dart';
import 'package:t_and_c_mobile/model/brands.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/distributors.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/user.dart';
import 'package:t_and_c_mobile/service/productApi.dart';

class ProductController extends ChangeNotifier {
  ProductController({this.api = const ProductApi()});
  ProductApi api;
  List<Brands>brands=[];
  List<ProductTyp>productBandTyp=[];
  List<Distributors>distributors=[];
  List<Order>orderlist=[];
  User? custommer;
  List<ProductTyp> producttypes = [];
  List<Collectiondata>productcollection=[];

  
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
   getlistdistributors() async {
    distributors.clear();
    distributors = await ProductApi.getlistdistributors();
    notifyListeners();
  }
    getOrderList() async {
    orderlist.clear();
    orderlist = await ProductApi.getOrderList();
    notifyListeners();
  }
   getcustommer() async {
    custommer = null;
    custommer = await ProductApi.getUser();
    notifyListeners();
  }
   getproductlist() async {
    custommer = null;
    custommer = await ProductApi.getUser();
    notifyListeners();
  }
  getproducttypes() async {
    producttypes.clear();
    producttypes = await ProductApi.getproducttypes();
    notifyListeners();
  }
  getproductcollection()async{
      productcollection.clear();
    productcollection = await ProductApi.getCollectionPro();
    notifyListeners();
  }
}
