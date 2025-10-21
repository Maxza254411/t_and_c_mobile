import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/order/orderDetail.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryDetail extends StatefulWidget {
  DeliveryDetail({super.key, required this.delivery_id});
  int delivery_id;

  @override
  State<DeliveryDetail> createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends State<DeliveryDetail> {
  Order? orderData;
  final Uri flash = Uri.parse('https://www.flashexpress.co.th/fle/tracking');
  final Uri yas = Uri.parse('https://tracking.yasservices.co.th/');


   Future<void> _launchUrlflash() async {
    if (!await launchUrl(flash, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $flash');
    }
  }
    Future<void> _launchUrlyas() async {
    if (!await launchUrl(yas, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $flash');
    }
  }

  Future<void> getapi() async {
    try {
      LoadingDialog.open(context);
      final delivery = await ProductApi.getOrderdelivery(
        delivery_id: widget.delivery_id,
      );
      orderData = delivery;
      setState(() {});
      LoadingDialog.close(context);
    } on Exception catch (e) {
      LoadingDialog.close(context);
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '$e',
          pressYes: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getapi();
    });
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
          "สถานะการจัดส่ง",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: orderData == null
          ? SizedBox.shrink()
          : Column(
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
                        ContainerHeader(
                          size: size,
                          text: 'หมายเลขการจัดส่ง',
                          status: false,
                          orderData: orderData,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: size.height * 0.07,
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: kButtonColor, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(orderData?.tracking_no??""),

                                GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                        text: orderData?.tracking_no.toString()??"",
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('คัดลอกสำเร็จ'),
                                        duration: Duration(seconds: 1),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: size.width * 0.1,

                                    height: size.height * 0.05,
                                    decoration: BoxDecoration(
                                      color: kButtonColor,
                                      border: Border.all(
                                        color: kButtonColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.copy,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                         Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap:() async{
                                          await _launchUrlflash();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: size.height * 0.05,
                                          width: size.width * 0.5,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: fbg,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: Image.asset(
                                                          "assets/icons/flash-express.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text("ติดตามสถานะการจัดส่ง"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                 GestureDetector(
                                  onTap: ()async{
                                     await _launchUrlyas();
                                  },
                                   child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: size.height * 0.05,
                                          width: size.width * 0.5,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: kButtonColor,
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 30,
                                                        height: 30,
                                                        child: Image.asset(
                                                          "assets/icons/Yas.png",
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text("ติดตามสถานะการจัดส่ง"),
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
                        ContainerHeader(
                          size: size,
                          text: 'รายการสินค้า',
                          status: false,
                          orderData: orderData,
                        ),
                        Column(
                          children: List.generate(
                            orderData!.items!.length,
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
                                    // Padding(
                                    //   padding: const EdgeInsets.only(left: 12),
                                    //   child:
                                    //       orderData!
                                    //               .items![index]
                                    //               .product!
                                    //               .image_url ==
                                    //           null
                                    //       ? Image.asset(
                                    //           "assets/images/LOGO CMYK-01.png",
                                    //         )
                                    //       : Image.network(
                                    //           orderData!
                                    //               .items![index]
                                    //               .product!
                                    //               .image_url!,
                                    //         ),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Container(
                                    //     width: 1,
                                    //     height: size.height * 0.05,
                                    //     color: kButtonColor,
                                    //   ),
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.7,
                                              child: Text(
                                                orderData!
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
                                              "X ${double.parse(orderData!.items![index].po_unit!).toStringAsFixed(0)}",
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
                                            Text("sku : "),
                                            Text(
                                              orderData!
                                                      .items![index]
                                                      .product_sku!
                                                      .sku ??
                                                  "",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("สี : "),
                                            Text(
                                              orderData!
                                                      .items![index]
                                                      .product_sku!
                                                      .color!
                                                      .name_th ??
                                                  "",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "฿ ${formatNumber(orderData!.items![index].product!.srp_inc_vat ?? "")}",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ราคาก่อน vat"),
                                  Text(
                                    "${formatNumber(orderData!.total_po_cost_ex_vat ?? "")} บาท",
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ราคารวม vat"),
                                  Text(
                                    "${formatNumber(orderData!.total_po_cost_inc_vat ?? "")} บาท",
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ราคารวม"),
                                  Text(
                                    "${formatNumber(orderData!.grand_total ?? "")} บาท",
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
              ],
            ),
    );
  }
}
