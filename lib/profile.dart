import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
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
      body: Column(
        children: [
          // Stack(
          //   clipBehavior: Clip.none,
          //   children: [
          //     Container(
          //       height:size.height*0.1,
          // margin:  EdgeInsets.all(16),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(12),
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.1),
          //       spreadRadius: 2,
          //       blurRadius: 6,
          //       offset: const Offset(0, 3),
          //     ),
          //   ],
          // ),
          // child: const Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: Text("ใส่ข้อความตรงนี้"),
          // ),
          //     ),

          //     // กล่องสีน้ำเงิน (โผล่มุมซ้าย)
          //     Positioned(

          // top: 0,
          // bottom: 0,
          // child: Container(
          //   width: 40,
          //   decoration: const BoxDecoration(
          //     color: Colors.blue,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(12),
          //       bottomLeft: Radius.circular(12),
          //     ),
          //   ),
          // ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
