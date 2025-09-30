import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/brands.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/distributors.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/widget/apiException.dart';

class ProductApi {
  const ProductApi();

  //ประเภทสินค้า
  // static Future<List<ProductTyp>> getproductlist() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   var headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //   final url = Uri.https(publicUrl, '/api/product-types');
  //   final response = await http.get(url, headers: headers);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     final data = convert.jsonDecode(response.body);
  //     // final data = convert.jsonDecode(response.body);
  //     final list = data["data"] as List;
  //     return list.map((e) => ProductTyp.fromJson(e)).toList();
  //   } else {
  //     final data = convert.jsonDecode(response.body);
  //     throw ApiException(data['message']);
  //   }
  // }

  // โปรดัคบาย ID
  // static Future<List<Data>> getproductbyid({required int id, int? page}) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   var headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };

  //   final url = Uri.https(publicUrl, '/api/product-types/$id/products', {
  //     "page": page?.toString() ?? "1",
  //   });
  //   final response = await http.get(url, headers: headers);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     final data = convert.jsonDecode(response.body);
  //     final list = data["data"] as List;
  //     return list.map((e) => Data.fromJson(e)).toList();
  //   } else {
  //     final data = convert.jsonDecode(response.body);
  //     throw ApiException(data['message']);
  //   }
  // }

  // เส้นโปรดัค
  // static Future<List<Data>> getproduct() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('token');
  //   var headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //   final url = Uri.https(publicUrl, '/api/products');
  //   final response = await http.get(url, headers: headers);
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     final data = convert.jsonDecode(response.body);
  //     // final data = convert.jsonDecode(response.body);
  //     final list = data["data"] as List;
  //     return list.map((e) => Data.fromJson(e)).toList();
  //   } else {
  //     final data = convert.jsonDecode(response.body);
  //     throw ApiException(data['message']);
  //   }
  // }

  //เส้น banner
  static Future<List<Brands>> listbrands() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final url = Uri.https(publicUrl, '/api/brands');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      // final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => Brands.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }

  //เอาประเภทสินค้าจากแบร์น
  static Future<List<ProductTyp>> getproductypBybrandid({
    required int brandid,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final url = Uri.https(publicUrl, '/api/brands/$brandid/product-types');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => ProductTyp.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }

  // โปรดัคบาย ID
  static Future<List<Data>> getProBandId({
    required int brandid,
    int? page,
    required int productTypid,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final url = Uri.https(
      publicUrl,
      '/api/brands/$brandid/$productTypid/products',
      {"page": page?.toString() ?? "1"},
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

  //เส้น ที่อยู่
  static Future<List<Distributors>> getlistdistributors() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final url = Uri.https(publicUrl, '/api/distributors');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      // final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => Distributors.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }

  static Future<Order> createOrder({
    required String distributor_id,
    required String qo_date,
    required String total_qty,
    required String total_cost_ex_vat,
    required String total_vat_amount,
    required String qo_total_cost_inc_vatdate,
    required String grand_total,
    required String products,
    required String address_id,
    required String slip_image,
    required String payment_method,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, '/api/quotation');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: convert.jsonEncode({
        "distributor_id": "1",
        "qo_date": "1999-01-01",
        "total_qty": "1",
        "total_cost_ex_vat": "1",
        "total_vat_amount": "1",
        "total_cost_inc_vat": "1",
        "grand_total": "1",
        "products": products,
        "address_id": "1",
        "slip_image": "",
        "payment_method": "cash",
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Order.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}
