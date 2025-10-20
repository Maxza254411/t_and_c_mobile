import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/order.dart';

class BillPage extends StatefulWidget {
  BillPage({super.key, required this.orderData});

  @override
  State<BillPage> createState() => _BillPageState();
  Order orderData;
}

class _BillPageState extends State<BillPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
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
          "ใบเสร็จ",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(           
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ordered By",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Admin Admin",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.5,
                                child: Text(
                                  widget.orderData.distributor?.company_name ??
                                      "",
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.5,
                                child: Text(
                                  widget.orderData.distributor?.address ?? "",
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/LOGO CMYK-01.png",
                                scale: 30,
                              ),

                              Text(
                                "บริษัทT&Cจำกัด",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Order Details
                      Divider(),
                      Text(
                        "Order Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kButtonColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order Date : ${widget.orderData.qo_date}",
                                ),
                                Text("Order ID : #${widget.orderData.qo_code}"),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      Divider(),

                      // Table Header
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(flex: 3, child: Text("ชื่อสินค้า")),
                          Expanded(flex: 2, child: Text("สี")),
                          //  Expanded(flex: 2, child: Text("sku")),
                          Expanded(flex: 2, child: Text("ราคา")),
                          Expanded(flex: 2, child: Text("จำนวน")),
                          Expanded(flex: 2, child: Text("รวม")),
                        ],
                      ),
                      const Divider(),

                      // Table Rows
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          widget.orderData.items!.length,
                          (index) => Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  widget
                                          .orderData
                                          .items![index]
                                          .product!
                                          .name_th ??
                                      "",
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget
                                          .orderData
                                          .items![index]
                                          .product_sku!
                                          .color!
                                          .name_th ??
                                      ""
                                          "",
                                ),
                              ),
                              //  Expanded(
                              //   flex: 2,
                              //   child: Text(
                              //     widget
                              //             .orderData
                              //             .items![index]
                              //             .product_sku!
                              //             .sku??
                              //         ""
                              //             "",
                              //   ),
                              // ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  formatNumber(
                                    widget
                                        .orderData
                                        .items![index]
                                        .product!
                                        .srp_inc_vat!,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  double.parse(
                                    widget.orderData.items![index].po_unit!,
                                  ).toStringAsFixed(0),
                                ),
                              ),
                          

                              Expanded(
                                flex: 2,
                                child: Text(
                                  formatNumber(
                                    widget
                                        .orderData
                                        .items![index]
                                        .product!
                                        .srp_inc_vat!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Divider(),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("ราคาก่อน vat", style: TextStyle()),
                                    Text(
                                      "${formatNumber(widget.orderData.total_po_cost_ex_vat ?? "")} บาท",
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("ราคารวม vat"),
                                    Text(
                                      "${formatNumber(widget.orderData.total_po_cost_inc_vat ?? "")} บาท",
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("จำนวนรวมทั้งหมด "),
                                    SizedBox(width: 8),
                                    Text(
                                      "${double.parse(widget.orderData.grand_total!).toStringAsFixed(2)} บาท",
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("วิธีการชำระเงิน"),
                                    SizedBox(width: 8),
                                    Text(
                                      widget.orderData.payment_method == "cash"
                                          ? "จ่ายผ่านบัญชี"
                                          : widget.orderData.payment_method ==
                                                "qrcode"
                                          ? "จ่ายผ่านQrcode"
                                          : "จ่ายผ่านเครดิต",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),

                      // Footer
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // 👈 ให้ชิดด้านบนทั้งคู่
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Sold By",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "สถานที่จัดส่ง",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '''123/45 ถนนสุขุมวิท 55 แขวงคลองตันเหนือ เขตวัฒนา กรุงเทพมหานคร 10110 โทร. 02-123-4567''',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16), // 👈 ระยะห่างระหว่าง 2 ฝั่ง
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Delivered To",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const Text(
                                    "ส่งถึง",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.orderData.distributor?.address ?? "",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12),
                      Divider(),
                    ],
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
