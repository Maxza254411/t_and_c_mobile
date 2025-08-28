import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
class TabletPage extends StatefulWidget {
  const TabletPage({super.key});

  @override
  State<TabletPage> createState() => _TabletPageState();
}

class _TabletPageState extends State<TabletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
   
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        leading: GestureDetector(
         onTap: () {
            Navigator.pop(context);
         },
          child: Image.asset('assets/icons/CaretLeft.png', scale: 15)),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Buy.png", scale: 15),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Notification.png", scale: 15),
          ),
        ],
        title: Text(
          "โปรไฟร์",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),

    );
  }
}