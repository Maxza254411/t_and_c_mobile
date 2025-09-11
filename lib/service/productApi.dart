import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/widget/apiException.dart';

class ProductApi {
  const ProductApi();

  //ประเภทสินค้า
 static Future<List<ProductTyp>> getproductlist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final url = Uri.https(publicUrl, '/api/product-types', 
    );
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
        final data = convert.jsonDecode(response.body);
      // final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => ProductTyp.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }
  // โปรดัคบาย ID
static Future<List<Data>> getproductbyid({required int id, int? page}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json'
  };

  final url = Uri.https(
    publicUrl,
    '/api/product-types/$id/products',
    {
      "page": page?.toString() ?? "1",
    },
  );
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = convert.jsonDecode(response.body);
    final list = data["data"] as List;
    return list.map((e) => Data.fromJson(e)).toList();
  } else {
    final data = convert.jsonDecode(response.body);
    throw ApiException(data['message']);
  }
}
// เส้นโปรดัค
 static Future<List<Data>> getproduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};
    final url = Uri.https(publicUrl, '/api/products', 
    );
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
        final data = convert.jsonDecode(response.body);
      // final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => Data.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }
  }