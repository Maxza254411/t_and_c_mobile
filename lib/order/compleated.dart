import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class Compleated extends StatefulWidget {
  const Compleated({super.key});

  @override
  State<Compleated> createState() => _CompleatedState();
}

class _CompleatedState extends State<Compleated> {
   final TextEditingController addes = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Notification.png", scale: 15),
          ),
        ],
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset("assets/icons/BucketIcon.png", scale: 15),
            ),
            //
            SizedBox(width: 10),
            Text(
              "สินค้าในตะกร้า",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  height: size.height * 0.2,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ที่ต้องจัดส่ง",

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '''123/45 ถนนสุขุมวิท 55 แขวงคลองตันเหนือ เขตวัฒนา กรุงเทพมหานคร 10110 โทร. 02-123-4567''',
                      ),
                      SizedBox(height: 10),
                      Text(
                        "รายละเอียดที่อยู่จัดส่ง",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                       InputTextFormField(
                        controller: addes,
                        size: size,
                        heights: size.height * 0.05,
                        imagestatus: false,
                        whatfield: true,
                        hintText: "เช่น ห้องเลขที่/ซอย",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  height: size.height * 0.13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
