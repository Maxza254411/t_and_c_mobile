import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
class Nontification extends StatefulWidget {
  const Nontification({super.key});

  @override
  State<Nontification> createState() => _NontificationState();
}

class _NontificationState extends State<Nontification> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     backgroundColor: kbgH,
       appBar: AppBar(
            backgroundColor: kButtonColor,
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            title: Text(
              "การแจ้งเตือน",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
    );
  }
}