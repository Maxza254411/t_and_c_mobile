import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/order/billpage.dart';

class Orderdetail extends StatefulWidget {
  Orderdetail({super.key, required this.orderData});

  Order orderData;
  @override
  State<Orderdetail> createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

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
          "รายละเอียดคำสั่งซื้อ",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ContainerHeader(size: size, text: 'ข้อมูลการจัดส่ง'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    "assets/icons/Package.png",
                                    scale: 20,
                                  ),
                                ),
                                SizedBox(width: 10),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                     Text(
                                  widget.orderData.distributor?.company_name ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  ),
                                    Text(
                                      widget.orderData.distributor?.address ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
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
                    ContainerHeader(size: size, text: 'รายการสินค้า',status: true,orderData: widget.orderData,),
                    Column(
                      children: List.generate(
                        widget.orderData.items!.length,
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
                                  padding: const EdgeInsets.only(left: 12),
                                  child:
                                      widget
                                              .orderData
                                              .items![index]
                                              .product!
                                              .image_url ==
                                          null
                                      ? Image.asset(
                                          "assets/images/LOGO CMYK-01.png",
                                        )
                                      : Image.network(
                                          widget
                                              .orderData
                                              .items![index]
                                              .product!
                                              .image_url!,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width * 0.4,
                                          child: Text(
                                            widget
                                                    .orderData
                                                    .items![index]
                                                    .product!
                                                    .name_th ??
                                                "",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.1),
                                        Text(
                                          "X ${double.parse(widget.orderData.items![index].po_unit!).toStringAsFixed(0)}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: kbgM,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(children: [
                                      Text("sku : "),
                                      Text(widget.orderData.items![index].product_sku!.sku??""),
                                    ],),
                                    Row(children: [
                                      Text("สี : "),
                                      Text(widget.orderData.items![index].product_sku!.color!.name_th??""),
                                    ],),
                                    Row(
                                      children: [
                                        Text(
                                          "฿ ${formatNumber(widget.orderData.items![index].product!.srp_inc_vat ?? "")}",
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ราคาก่อน vat"),
                              Text(
                                "${formatNumber(widget.orderData.total_po_cost_ex_vat ?? "")} บาท",
                              ),
                            ],
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ราคารวม vat"),
                              Text(
                                "${formatNumber(widget.orderData.total_po_cost_inc_vat ?? "")} บาท",
                              ),
                            ],
                          ),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ราคารวม"),
                              Text(
                                "${formatNumber(widget.orderData.grand_total ?? "")} บาท",
                              ),
                            ],
                          ),
                        ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerHeader(size: size, text: 'วิธีชำระเงิน'),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
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
                                            child: Text(
                                             widget.orderData.payment_method=="cash"
                                             ?"จ่ายผ่านบัญชี"
                                             : widget.orderData.payment_method=="qrcode"
                                             ?"จ่ายผ่านพร้อมเพลย์"
                                             :"จ่ายผ่านเครดิต",
                                              style: TextStyle(fontSize: 16),
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
  ContainerHeader({
    super.key,
    required this.size,
    required this.text,
    this.status = false,
    this.orderData,

  });

  final Size size;
  String text;
  bool? status;
  Order? orderData;

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
              status==true
          ? GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BillPage(orderData: orderData!)));
            },
            child: Icon(Icons.description,color: Colors.white,))
          :SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
