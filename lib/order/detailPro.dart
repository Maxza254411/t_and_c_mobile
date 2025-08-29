import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';

class Detailpro extends StatefulWidget {
  Detailpro({super.key, required this.proName,required this.proPice});
  String proName;
  String proPice;

  @override
  State<Detailpro> createState() => _DetailproState();
}

class _DetailproState extends State<Detailpro> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/BuyBack.png", scale: 15),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, color: Colors.black),
        ),
        title: Text(
          widget.proName,
          style: TextStyle(color: kbgM, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Image.asset("assets/images/NoImage.jpg", ),
          ),
       SizedBox(height: 10,),
          Row(
            children: [
               SizedBox(width: size.width * 0.05),
              Text(
                 widget.proName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
               SizedBox(width: size.width * 0.05),
              Text(
                 widget.proPice,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
