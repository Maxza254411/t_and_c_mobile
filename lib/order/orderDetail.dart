
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:t_and_c_mobile/addressPage.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/widget/buildRadioOption.dart';


class Orderdetail extends StatefulWidget {
  Orderdetail({
    super.key,
  });

  List<Shoping> selectedItems = []; // รับสินค้าที่ติ๊ก

  @override
  State<Orderdetail> createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {

  String? selectedAddress;
  String? tel_no;
  final _controller = ScreenshotController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

  
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int totalQuantity = widget.selectedItems.fold(
      0,
      (previousValue, element) => previousValue + element.quantity,
    );

    return Consumer<ProductController>(
      builder: (context, controller, child) {
        final distributors = controller.distributors;

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
              "สั่งซื้อสินค้า",
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
                              distributors.isEmpty
                                  ? SizedBox.shrink()
                                  : GestureDetector(
                                      onTap: () async {
                                        // final out = await Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => AddressPage(
                                        //       distributors: distributors,
                                        //     ),
                                        //   ),
                                        // );
                                        // setState(() {
                                        //   selectedAddress = out;
                                        // });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: kButtonColor,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: selectedAddress == null
                                            ? Text(
                                                distributors[0].address ?? "",
                                                style: TextStyle(fontSize: 16),
                                              )
                                            : Text(
                                                "$selectedAddress",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                      ),
                                    ),
                              SizedBox(height: 10),
                              Text(
                                "รายละเอียดที่อยู่จัดส่ง",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      
                                   Container(
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
                        // Column(
                        //   children: [
                        //     ListTile(
                        //       leading: Image.asset(
                        //         "assets/icons/User.png",
                        //         scale: 15,
                        //       ),

                        //       title: Text("ชื่อผู้รับสินค้า"),
                        //       subtitle: Text(
                        //         "${first_name ?? ""} ${last_name ?? ""}",
                        //         style: TextStyle(color: kButtonColor),
                        //       ),
                        //     ),
                        //     Divider(),
                        //     ListTile(
                        //       leading: Image.asset(
                        //         "assets/icons/PhoneCall.png",
                        //         scale: 15,
                        //       ),
                        //       title: Text("เบอร์โทรผู้รับสินค้า"),
                        //       subtitle: Text(
                        //         tel_no ?? "-",
                        //         style: TextStyle(color: kButtonColor),
                        //       ),
                        //     ),
                        //     Divider(),

                        //     ListTile(
                        //       leading: Image.asset(
                        //         "assets/icons/ChatCircleDots.png",
                        //         scale: 15,
                        //       ),
                        //       title: Text("ข้อความถึงหนักงาน"),
                        //       subtitle: widget.status == true
                        //           ? Container(
                        //               height: size.height * 0.05,
                        //               width: size.width * 1,
                        //               decoration: BoxDecoration(
                        //                 borderRadius: BorderRadius.circular(8),
                        //                 color: const Color.fromARGB(
                        //                   255,
                        //                   241,
                        //                   241,
                        //                   241,
                        //                 ),
                        //               ),
                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(8.0),
                        //                 child: Text("ถึงแล้วโทรมานะครับ"),
                        //               ),
                        //             )
                        //           : InputTextFormField(
                        //               maxLines: 1,
                        //               fontsize: 16,
                        //               controller: talk,
                        //               size: size,
                        //               heights: size.height * 0.05,
                        //               imagestatus: false,
                        //               whatfield: true,
                        //               hintText: "พิมพ์ข้อความ",
                        //               width: size.width * 1,
                        //             ),
                        //     ),
                        //   ],
                        // ),
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
                        // ContainerHeader(
                        //   size: size,
                        //   text: 'รายการสินค้า',
                        //   status: widget.slipe_status,
                        // ),
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
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
                                          " บาท",
                                        ),
                                      ],
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
                        ContainerHeader(size: size, text: 'วิธีการชำระเงิน'),
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
                                    print(selectedPay);
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
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    // เพิ่มความสูงหน่อยเพื่อให้มีที่วาง Tab
                    width: size.width * 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        selectedPay == "Qr"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ContainerHeader(
                                      size: size,
                                      text: 'จ่ายผ่านพร้อมเพลย์',
                                    ),
                                    Text(
                                      "บัญชีพร้อมเพลย์ ธนาคาร",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // 🏦 ชื่อธนาคาร
                                    Screenshot(
                                      controller: _controller,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                "assets/images/LHVGYY_qrcode.png",
                                                height: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                   
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 🏦 ชื่อธนาคาร
                                    ContainerHeader(
                                      size: size,
                                      text: 'จ่ายผ่านบัญชี',
                                    ),
                                    Text(
                                      "ธนาคารกสิกรไทย",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    // 🔢 เลขบัญชี
                                    Text(
                                      "123-456-789-0",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        letterSpacing: 2,
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                    // 📋 ปุ่มคัดลอก
                                    SizedBox(
                                      width: size.width * 0.4,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: "1234567890"),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "คัดลอกเลขบัญชีแล้ว",
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.copy),
                                        label: Text("คัดลอกเลขบัญชี"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kButtonColor,
                                          foregroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

               
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       "สินค้ารวม ${totalQuantity} ชิ้น",
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //     Text(
                    //       " ฿ ${formatNumber(widget.totalPrice)} ",
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //         color: kButtonColor,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 12), // เว้นระยะห่างก่อนปุ่ม
                    // --- ปุ่มชำระเงิน ---
                    GestureDetector(
                      onTap: () async {
                      
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
      },
    );
  }

  //  _captureScrean()async{
  //  final image=  await _controller.capture();
  //  }
  // buildImage()=> Padding(
  // padding: const EdgeInsets.all(8.0),
  // child: ClipRRect(
  // borderRadius: BorderRadius.circular(8),
  // child: Image.asset(
  //  "assets/images/LHVGYY_qrcode.png",
  // height: 150,
  // fit: BoxFit.cover,
  // ),
  // ),
  // );
  // Future<String>saveScreenshot(Uint8List bytes)async{
  //   await [Permission.storage].request();
  //   final time = DateTime.now();
  //   final name ='Screenshot_$time';
  //   final result = await ImageGallerySaver.saveImage(bytes,name: name);
  //   return result['filePath'];
  // }
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
              // status == true
              //     ? GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => BillPage()),
              //           );
              //         },
              //         child: Padding(
              //           padding: const EdgeInsets.only(right: 10),
              //           child: Icon(Icons.receipt_long, color: Colors.white),
              //         ),
              //       )
              //     : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
