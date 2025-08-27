import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kbgM,
      appBar: AppBar(
        backgroundColor: kButtonColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Buy.png", scale: 15),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Notification.png", scale: 15),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/icons/Vector.png", scale: 15),
        ),
        title: Text(
          "Admin Admin",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height:size.height*0.08 ,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: kbgf),
              ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: InputTextFormField(
                          controller: search,
                          size: size,
                          heights: size.height * 0.05, imagestatus: true,images:"assets/icons/Search.png" ,
                        ),
               ),

            ],
          ),
        ],
      ),
    );
  }
}
