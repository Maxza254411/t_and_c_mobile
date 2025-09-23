import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/homepage.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/order/billpage.dart';
import 'package:t_and_c_mobile/payment/paybank.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/widget/buildRadioOption.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class Compleated extends StatefulWidget {
  Compleated({
    super.key,
    required this.status,
    required this.selectedItems,
    this.totalPrice,
    this.image,
    required this.slipe_status,
  });
  bool status;
  List<Shoping> selectedItems = []; // รับสินค้าที่ติ๊ก
  double? totalPrice;
  String? image;
  bool slipe_status;
  @override
  State<Compleated> createState() => _CompleatedState();
}

class _CompleatedState extends State<Compleated> {
  final TextEditingController addes = TextEditingController();
  final TextEditingController talk = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int totalQuantity = widget.selectedItems.fold(
      0,
      (previousValue, element) => previousValue + element.quantity,
    );

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
                          widget.status == true
                              ? Container(
                                  height: size.height * 0.1,
                                  width: size.width * 1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color.fromARGB(
                                      255,
                                      241,
                                      241,
                                      241,
                                    ),
                                  ),

                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("เอาวางไว้ชั่น 2"),
                                  ),
                                )
                              : InputTextFormField(
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
                          subtitle: widget.status == true
                              ? Container(
                                  height: size.height * 0.05,
                                  width: size.width * 1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: const Color.fromARGB(
                                      255,
                                      241,
                                      241,
                                      241,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("ถึงแล้วโทรมานะครับ"),
                                  ),
                                )
                              : InputTextFormField(
                                  maxLines: 1,
                                  fontsize: 16,
                                  controller: talk,
                                  size: size,
                                  heights: size.height * 0.05,
                                  imagestatus: false,
                                  whatfield: true,
                                  hintText: "พิมพ์ข้อความ",
                                  width: size.width * 1,
                                ),
                        ),
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
                    ContainerHeader(
                      size: size,
                      text: 'รายการสินค้า',
                      status: widget.slipe_status,
                    ),
                    widget.selectedItems.isEmpty
                        ? SizedBox.shrink()
                        : Column(
                            children: [
                              Column(
                                children: List.generate(
                                  widget.selectedItems.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      height: size.height * 0.1,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 12,
                                            ),
                                            child:
                                                widget
                                                        .selectedItems[index]
                                                        .image ==
                                                    null
                                                ? Image.asset(
                                                    "assets/images/LOGO CMYK-01.png",
                                                  )
                                                : Image.network(
                                                    widget
                                                        .selectedItems[index]
                                                        .image!,
                                                  ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: size.width * 0.4,
                                                    child: Text(
                                                      widget
                                                          .selectedItems![index]
                                                          .name,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.1,
                                                  ),
                                                  Text(
                                                    "X ${widget.selectedItems![index].quantity.toString()}",

                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kbgM,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    widget
                                                        .selectedItems![index]
                                                        .price
                                                        .toString(),
                                                  ),
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
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("ราคารวม"),
                                    Text(
                                      "${formatNumber(widget.totalPrice)} บาท",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    widget.status == true
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),

                              child: Column(
                                children: [
                                  Divider(color: kButtonColor),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("ราคารวม"),
                                        Text(
                                          "0.00 บาท",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: kButtonColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
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
                    // widget.status == true
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: BuildRadioOption(
                    //           title: "เงินสด", // ชื่อวิธีจ่าย
                    //           value:
                    //               pay[0]['value']!, // ค่า เช่น "cash" หรือ "promptpay"
                    //           groupValue:
                    //               selectedPay, // state ที่เก็บค่าที่เลือก
                    //           onChanged: (val) {
                    //             setState(() {
                    //               selectedPay = val;
                    //             });
                    //           },
                    //         ),
                    //       )
                    // :
                    Column(
                      children: List.generate(
                        pay.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BuildRadioOption(
                            title: pay[index]['pay']!,
                            value: pay[index]['value']!,
                            groupValue: selectedPay,
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
            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Container(
            //     height:
            //         size.height * 0.5, // เพิ่มความสูงหน่อยเพื่อให้มีที่วาง Tab
            //     width: size.width * 1,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: DefaultTabController(
            //       length: 2, // จำนวนแท็บ
            //       child: Column(
            //         children: [
            //           // --- แถบ TabBar ---
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: TabBar(
            //               indicator: BoxDecoration(
            //                 color: kButtonColor,
            //                 borderRadius: BorderRadius.circular(8),
            //               ),
            //               indicatorPadding: EdgeInsets.symmetric(
            //                 vertical: 10,
            //               ), // << ปรับขนาด
            //               labelColor: Colors.white,
            //               unselectedLabelColor: Colors.black,
            //               tabs: [
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Tab(text: "เลขบัญชี"),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Tab(text: "พร้อมเพย์"),
            //                 ),
            //               ],
            //             ),
            //           ),

            //           // --- เนื้อหาในแต่ละแท็บ ---
            //           Expanded(
            //             child: TabBarView(
            //               children: [
            //                 Center(
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       // 🏦 ชื่อธนาคาร
            //                       Text(
            //                         "ธนาคารกสิกรไทย",
            //                         style: TextStyle(
            //                           fontSize: 18,
            //                           fontWeight: FontWeight.bold,
            //                         ),
            //                       ),

            //                       const SizedBox(height: 12),

            //                       // 🔢 เลขบัญชี
            //                       Text(
            //                         "123-456-789-0",
            //                         style: TextStyle(
            //                           fontSize: 24,
            //                           fontWeight: FontWeight.bold,
            //                           color: Colors.black87,
            //                           letterSpacing: 2,
            //                         ),
            //                       ),

            //                       const SizedBox(height: 20),

            //                       // 📋 ปุ่มคัดลอก
            //                       ElevatedButton.icon(
            //                         onPressed: () {
            //                           Clipboard.setData(
            //                             ClipboardData(text: "1234567890"),
            //                           );
            //                           ScaffoldMessenger.of(
            //                             context,
            //                           ).showSnackBar(
            //                             SnackBar(
            //                               content: Text("คัดลอกเลขบัญชีแล้ว"),
            //                             ),
            //                           );
            //                         },
            //                         icon: Icon(Icons.copy),
            //                         label: Text("คัดลอกเลขบัญชี"),
            //                         style: ElevatedButton.styleFrom(
            //                           backgroundColor: kButtonColor,
            //                           foregroundColor: Colors.white,
            //                           padding: EdgeInsets.symmetric(
            //                             horizontal: 20,
            //                             vertical: 12,
            //                           ),
            //                           shape: RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.circular(8),
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),

            //                 Center(child: Text("เนื้อหาของแท็บ 2")),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0), // ขยายขอบนอกนิดหน่อย
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ), // เพิ่ม padding ข้างใน
            child: Column(
              mainAxisSize: MainAxisSize.min, // ให้ Container สูงตามเนื้อหา
              children: [
                // --- แถวราคารวม ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "สินค้ารวม ${totalQuantity} ชิ้น",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      " ฿ ${formatNumber(widget.totalPrice)} ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kButtonColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12), // เว้นระยะห่างก่อนปุ่ม
                // --- ปุ่มชำระเงิน ---
                GestureDetector(
                  onTap: () async {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> Paybank()));
                    final cart = Provider.of<CartProvider>(
                      context,
                      listen: false,
                    );

                    // ลบเฉพาะสินค้าที่เลือก
                    cart.removeSelected(widget.selectedItems);

                    final out = await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => SucesDialog(
                        title: 'แจ้งเตือน',
                        description: 'ชำระเงินสำเร็จ',
                      ),
                    );

                    if (out == true) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => FirstPage()),
                        (route) => false,
                      );
                    }
                  },
                  child: Container(
                    height: size.height * 0.07, // สูงขึ้นหน่อย
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kButtonColor,
                    ),
                    child: Center(
                      child: Text(
                        "สั่งสินค้า",
                        style: TextStyle(
                          fontSize: 18, // ขยายฟอนต์
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
        ),
      ),
    );
  }
}

class ContainerHeader extends StatelessWidget {
  ContainerHeader({
    super.key,
    required this.size,
    required this.text,
    this.status = false,
  });

  final Size size;
  String text;
  bool? status;

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: kbgf,
                ),
              ),
              status == true
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BillPage()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.receipt_long, color: Colors.white),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
