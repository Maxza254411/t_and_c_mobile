import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/order/compleated.dart';

import 'package:t_and_c_mobile/widget/field.dart';

class History extends StatefulWidget {
   History({super.key,});
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,

        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Notification.png", scale: 15),
          ),
        ],
        centerTitle: true,
        title: Text(
          "ประวัติการสั่งซื้อ",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.08,
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: kbgf),
              child: InputTextFormField(
                hintText: "Search here ...",
                controller: search,
                size: size,
                heights: size.height * 0.08,
                imagestatus: true,
                images: "assets/icons/Search.png",
                whatfield: false,
                width: double.infinity,
              ),
                ),
               Column(
                 children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Compleated(status: true,)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Order #00000"),
                                  Text("จัดส่งสำเร็จ >",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: kButtonColor),),
                                ],
                              ),
                            ),
                            Divider(color: kbgM),
                            Column(
                              children: List.generate(
                                2,
                                (index) => Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/NoImage.jpg",
                                          scale: 15,
                                        ),
                                        Text("ชื่อสินค้า"),
                                        Spacer(),
                                        Text("0.00 บาท"),
                                      ],
                                    ),
                                    SizedBox(height: 10,)
                                  ],
                                ),
                              ),
                            ),
                            Divider(color: kbgM),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total"),
                                
                              Text("0.00 บาท",style:TextStyle(fontSize: 20,color: kButtonColor,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
            ),
     
          ],
        ),
      ),
    );
  }
}
