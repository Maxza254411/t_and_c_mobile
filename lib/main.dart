import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/homePage.dart';
import 'package:t_and_c_mobile/login.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // โหลด userId จาก SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('userId') ?? ''; // ถ้ายังไม่มี ให้เป็น ''

  runApp(MyApp(userId: userId.toString()));
}

class MyApp extends StatelessWidget {
  final String userId; // รับ userId
  MyApp({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartProvider(userId)), // ใส่ userId
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'IBMPlexSansThai',
        ),
        home: Loginpage(),
        // FirstPage(),
      ),
    );
  }
}
