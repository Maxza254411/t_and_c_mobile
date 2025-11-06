import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kButtonColor = Color(0xFF2C64AF);
const kbgf = Color(0xFFE4E4E4);
const kbgM = Color(0xFFE939393);
const ktextColr = Color(0xFFED2324);
const kbgH = Color(0xFFEE7E7E7);
const kbgc = Color(0xFFE9FFF8);
const kline = Color(0xFFE6CE131);
const fbg = Color(0xFFFFEA33);   

// const String publicUrl = 'dev-erp.tnc-thailand.com';
const String publicUrl = 'erp.tnc-thailand.com';

final List<String> imgList = [
  "assets/images/banner 1.png",
  "assets/images/banner 2.png",
  "assets/images/banner 3.png",
];

List<Map<String, String>> pay = [
  {"pay": "จ่ายผ่านบัญชี", "value": "cash"},
  {"pay": "จ่ายผ่าน QR Code", "value": "qrcode"},
  {"pay": "จ่ายผ่านเครดิต", "value": "credit"},
];

String? selectedPay = "cash";

String formatNumber(dynamic value, {int decimal = 2}) {
  double number = 0;
  if (value is String) {
    number = double.tryParse(value) ?? 0;
  } else if (value is num) {
    number = value.toDouble();
  }

  // format โดยใช้ intl
  final formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
    decimalDigits: decimal,
  );

  return formatter.format(number).trim();
}
String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
