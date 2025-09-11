import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/compleated.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';

class Detailpro extends StatefulWidget {
  Detailpro({
    super.key,
    required this.proName,
    required this.proPice,
    required this.detail,
    required this.color,
  });
  String proName;
  String proPice;
  String detail;
  String color;

  @override
  State<Detailpro> createState() => _DetailproState();
}

class _DetailproState extends State<Detailpro> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Bucket()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset("assets/icons/BuyBack.png", scale: 15),

                  if (cart.items.isNotEmpty) // แสดง badge เมื่อมีสินค้า
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          "${cart.items.length}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Image.asset("assets/images/NoImage.jpg")),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(width: size.width * 0.05),
                SizedBox(
                  width: size.width * 0.8,
                  child: Text(
                    widget.proName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
              SizedBox(height: size.height * 0.001),
            Row(
              children: [
              SizedBox(width: size.width*0.05,),
                
                Text(
                  "${widget.proPice} บาท ",
                  
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.001),
            Row(
              children: [
              SizedBox(width: size.width*0.05,),
                
                Text(
                  "สี ${widget.color}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
           SizedBox(height: size.height*0.19,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.08,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kButtonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          final shoping = Shoping(
                            name: widget.proName,
                            price: widget.proPice,
                            detail: widget.detail, 
                            color:widget.color
                          );

                          // เรียก provider มาเพิ่มสินค้าในตะกร้า
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).addItem(shoping);

                          // ไปหน้า Bucket
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Bucket()),
                          );
                        },
                        child: Text(
                          "เพิ่มในตะกร้า",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kbgf,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: size.width * 0.4,
                      height: size.height * 0.08,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kbgM,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Compleated(status: false),
                            ),
                          );
                        },
                        child: Text(
                          "สั่งซื้อ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kbgf,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
