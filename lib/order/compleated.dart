import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/homepage.dart';
import 'package:t_and_c_mobile/widget/buildRadioOption.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class Compleated extends StatefulWidget {
   Compleated({super.key,required this.status});
bool status;
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
        centerTitle: true,
        title: Text(
          "สั้งซื้อสินค้า",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    child: Padding(
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
                            fontsize: 16,
                            controller: addes,
                            size: size,
                            heights: size.height * 0.1,
                            imagestatus: false,
                            whatfield: true,
                            hintText: "เช่น ห้องเลขที่/ซอย",
                            width: size.width * 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                // height: size.height * 0.39,
                child: Column(
                  children: [
                    ContainerHeader(size: size, text: 'ชื่อลูกค้า'),
                    Column(
                      children: [
                        ListTile(
                          leading: Image.asset(
                            "assets/icons/User.png",
                            scale: 15,
                          ),
                          title: Text("ชื่อผู้รับสินค้า"),
                          subtitle: Text(
                            "admin admin",
                            style: TextStyle(color: kButtonColor),
                          ),
                        ),
                        Divider(),

                        ListTile(
                          leading: Image.asset(
                            "assets/icons/PhoneCall.png",
                            scale: 15,
                          ),
                          title: Text("เบอร์โทรผู้รับสินค้า"),
                          subtitle: Text(
                            "000-000-xxxx",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        Divider(),

                        ListTile(
                          leading: Image.asset(
                            "assets/icons/ChatCircleDots.png",
                            scale: 15,
                          ),
                          title: Text("ข้อความถึงหนักงาน"),
                          subtitle: InputTextFormField(
                            maxLines: 1,
                            fontsize: 16,
                            controller: addes,
                            size: size,
                            heights: size.height * 0.05,
                            imagestatus: false,
                            whatfield: true,
                            hintText: "พิมพ์ข้อความ",
                            width: size.width * 1,
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ContainerHeader(size: size, text: 'รายการสินค้า'),
                    Column(
                      children: List.generate(
                        products.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            height: size.height * 0.06,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Image.asset(products[index]['image']!),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 1,
                                    height: size.height * 0.05,
                                    color: kButtonColor,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(products[index]["title"]!),
                                        SizedBox(width: size.width * 0.1),
                                        Text(
                                          "X 1",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: kbgM,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(products[index]["price"]!),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ContainerHeader(size: size, text: 'วิธีการชำระเงิน'),

                    // แสดงวิธีจ่ายเงิน
                    Column(
                      children: List.generate(
                        pay.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BuildRadioOption(
                            title: pay[index]['pay']!, // ชื่อวิธีจ่าย
                            value:
                                pay[index]['value']!, // ค่า เช่น "cash" หรือ "promptpay"
                            groupValue: selectedPay, // state ที่เก็บค่าที่เลือก
                            onChanged: (val) {
                              setState(() {
                                selectedPay = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),

                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("ราคารวม"), Text("0.00 บาท")],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final out = await showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => SucesDialog(
                            title: 'แจ้งเตือน',
                            description: 'สำเร็จ',
                          ),
                        );
                        if (out == true) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FirstPage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kButtonColor,
                          ),
                          height: size.height * 0.05,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "ชำระเงิน",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kbgf,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerHeader extends StatelessWidget {
  ContainerHeader({super.key, required this.size, required this.text});

  final Size size;
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: size.height * 0.05, // ความสูง
        width: size.width * 1, // ความกว้าง
        decoration: BoxDecoration(
          color: kButtonColor, // สีพื้นหลัง
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kbgf,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
