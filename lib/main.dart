import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/homePage.dart';
import 'package:t_and_c_mobile/login.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:shared_preferences/shared_preferences.dart';


String? token;
int? userId;
late SharedPreferences prefs;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');
  userId = prefs.getInt('userId');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final String userId; // รับ userId
  MyApp(  {super.key,});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductController()),
        ChangeNotifierProvider(create: (_) => CartProvider(userId!)), // ใส่ userId
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'IBMPlexSansThai',
        ),
        home: token == null ? Loginpage() : FirstPage(),
        // Loginpage(),
        // FirstPage(),
      ),
    );
  }
}
