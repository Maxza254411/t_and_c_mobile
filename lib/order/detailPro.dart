import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/compleated.dart';

class Detailpro extends StatefulWidget {
  Detailpro({
    super.key,
    required this.proName,
    required this.proPice,
    required this.detail,
  });
  String proName;
  String proPice;
  String detail;

  @override
  State<Detailpro> createState() => _DetailproState();
}

class _DetailproState extends State<Detailpro> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("assets/icons/BuyBack.png", scale: 15),
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
                  width: size.width*0.8,
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: List.generate(
            //       colorPro.length,
            //       (index) => Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Image.asset(
            //           '${colorPro[index]['color']}',
            //           scale: 10,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Row(
              children: [
                SizedBox(width: size.width * 0.05),
                Text(
                  "คำบรรยายสินค้า",
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
                SizedBox(
                  width: size.width * 0.8,
                  child: Text(
                    widget.detail,
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            
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
                            MaterialPageRoute(builder: (context) => Compleated(status: false,)),
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
