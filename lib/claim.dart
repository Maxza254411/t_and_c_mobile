import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';

class ClaimPage extends StatefulWidget {
  const ClaimPage({super.key});

  @override
  State<ClaimPage> createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> {
 
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
              "เคลมสินค้า",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
    );
  }
}