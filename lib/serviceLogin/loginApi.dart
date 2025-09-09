import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/widget/apiException.dart';

class LoginApi {
  const LoginApi();

    static Future login(
    String username,
    String password,
  ) async {
    
    final url = Uri.https(publicUrl,'/api/login');
    final response = await http.post(url, body: {
      'email': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return data;
    } else {
      final data = convert.jsonDecode(response.body);
      throw ApiException(data['message']);
    }
  }

}