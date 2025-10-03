import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/address.dart';
import 'package:t_and_c_mobile/model/brands.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/distributors.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/model/product.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/widget/apiException.dart';

class ProductApi {
  const ProductApi();


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

  //เส้น ที่อยู่ลูกค้า
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
    // Addressby ID
  static Future<List<Address>> getAddressbyid({
    required int distributor_id,
   }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final url = Uri.https(publicUrl, '/api/distributors/$distributor_id/shipping-address');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => Address.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }

  // สร้าง Order 
  static Future<Order> createOrder({
    required String distributor_id,
    required String qo_date,
    required String total_qty,
    required String total_cost_ex_vat,
    required String total_vat_amount,
    required String total_cost_inc_vat,
    required String grand_total,
    required List<Product> products,
    required String address_id,
    required File slip_image, // path ของไฟล์
    required String payment_method,
   }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.https(publicUrl, '/api/quotation');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['distributor_id'] = distributor_id;
    request.fields['qo_date'] = "1999-01-01";
    request.fields['total_qty'] = total_qty;
    request.fields['total_cost_ex_vat'] = total_cost_ex_vat;
    request.fields['total_vat_amount'] = total_vat_amount;
    request.fields['total_cost_inc_vat'] = total_cost_inc_vat;
    request.fields['grand_total'] = grand_total;
    request.fields['address_id'] = address_id;
    request.fields['payment_method'] = payment_method;
    request.fields['products'] = convert.jsonEncode(
      products.map((p) => p.toJson()).toList(),
    );
  
    if (slip_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'slip_image',
          slip_image.path, // ต้องเป็น path จริง ๆ ของไฟล์
        ),
      );
    }

    // ส่ง request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      return Order.fromJson(data);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  // เส้น OrderList
  static Future<List<Order>> getOrderList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final url = Uri.https(publicUrl, '/api/quotation');
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = convert.jsonDecode(response.body);
      final list = data["data"] as List;
      return list.map((e) => Order.fromJson(e)).toList();
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }

}
