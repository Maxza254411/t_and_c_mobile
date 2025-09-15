import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kButtonColor = Color(0xFF2C64AF);
const kbgf = Color(0xFFE4E4E4);
const kbgM = Color(0xFFE939393);
const ktextColr = Color(0xFFED2324);
const kbgH = Color(0xFFEE7E7E7);
const kbgc = Color(0xFFE9FFF8);

const String publicUrl = 'dev-erp.tnc-thailand.com';

final List<String> imgList = [
  "assets/images/banner 1.png",
  "assets/images/banner 2.png",
  "assets/images/banner 3.png",
];


List<Map<String, String>> pay = [
  {"pay": "เงินสด", "value": "cash"},
  {"pay": "พร้อมเพลย์", "value": "promptpay"},
  {"pay": "บัตรเครดิต", "value": "credit"},
];

List<Map<String, String>> orderbill = [
  {"productname": "Airpods pro", "pice": "0.00","qty":"1","discount":"0.00","total":"0.00"},
   {"productname": "Aestheic Mug - white", "pice": "0.00","qty":"1","discount":"0.00","total":"0.00"},
 {"productname": "Gaming Monitor", "pice": "0.00","qty":"1","discount":"0.00","total":"0.00"},
];

String? selectedPay = "cash"; // ค่าเริ่มต้น

String formatNumber(dynamic value, {int decimal = 2}) {
  // แปลงค่าให้เป็น double ก่อน
  double number = 0;
  if (value is String) {
    number = double.tryParse(value) ?? 0;
  } else if (value is num) {
    number = value.toDouble();
  }

  // format โดยใช้ intl
  final formatter = NumberFormat.currency(
    locale: 'en_US', // ใช้ en_US จะมีลูกน้ำคั่นหลักพัน
    symbol: '', // ไม่ใส่สัญลักษณ์เงิน
    decimalDigits: decimal, // จำนวนทศนิยม
  );

  return formatter.format(number).trim();
}