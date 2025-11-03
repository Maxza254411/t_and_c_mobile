import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/model/quotation.dart';
import 'package:t_and_c_mobile/order/billpage.dart';
import 'package:t_and_c_mobile/order/deliveryDetail.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/widget/buildRadioOption.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';
import 'package:url_launcher/url_launcher.dart';

class Orderdetail extends StatefulWidget {
  Orderdetail({super.key, required this.quotation_id});

  // Order orderData;
  int quotation_id;
  @override
  State<Orderdetail> createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {
  File? _image;
  final _controller = ScreenshotController();
  int? currentStep;
  Order? orderData;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    ); // หรือ camera

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> getapi() async {
    try {
      LoadingDialog.open(context);
      final listOrder = await ProductApi.getOrderDetails(
        quotation_id: widget.quotation_id,
      );
      orderData = listOrder;
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

  Future<void> _captureAndSave() async {
    try {
      final Uint8List? imageBytes = await _controller.capture();
      if (imageBytes != null) {
        final result = await ImageGallerySaverPlus.saveImage(
          imageBytes,
          quality: 100,
          name: "qr_code_promptpay",
        );

        if (result['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("บันทึกรูปภาพเรียบร้อยแล้ว")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("บันทึกรูปภาพไม่สำเร็จ")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $e")));
    }
  }

  Future<void> checkstatus() async {
    orderData?.status == "finance_approval"
        ? currentStep = 0
        : orderData?.status == "doc_to_peak"
        ? currentStep = 1
        : currentStep = 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await checkstatus();
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
          "รายละเอียดคำสั่งซื้อ",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: orderData == null
          ? SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                children: [
                  
                  orderData!.delivery_orders!.isEmpty
                      ? SizedBox.shrink()
                      : Padding(
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
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: List.generate(
                                          orderData!.delivery_orders!.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DeliveryDetail(
                                                          delivery_id: orderData!
                                                              .delivery_orders![index]
                                                              .id,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: size.height * 0.07,
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: kButtonColor,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${orderData!.delivery_orders![index].dn_code}",
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_sharp,
                                                      color: kButtonColor,
                                                    ),
                                                  ],
                                                ),
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                          ContainerHeader(size: size, text: 'ชำระเงินผ่าน'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kButtonColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                orderData?.payment_method == "cash"
                                    ? "จ่ายผ่านบัญชี"
                                    : orderData?.payment_method == "qrcode"
                                    ? "จ่ายผ่าน Qr code"
                                    : "จ่ายผ่านเครดิต",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          orderData?.payment_method == "credit"
                              ? SafeArea(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              ContainerHeader(
                                                size: size,
                                                text: 'เลือกวิธีชำระเงิน',
                                              ),
                                              Column(
                                                children: List.generate(
                                                  2,
                                                  (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: BuildRadioOption(
                                                      title: pay[index]['pay']!,
                                                      value:
                                                          pay[index]['value']!,
                                                      groupValue: selectedPay,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          selectedPay = val;
                                                          print(selectedPay);
                                                        });
                                                      }, typ: 'money',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      selectedPay == "qrcode"
                                          ? Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ContainerHeader(
                                                    size: size,
                                                    text: 'จ่ายผ่าน QR Code',
                                                  ),
                                                  Text(
                                                    "บัญชี QR Code ธนาคาร",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  // 🏦 ชื่อธนาคาร
                                                  Screenshot(
                                                    controller: _controller,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            child: Image.asset(
                                                              "assets/images/QrCodeTnC.jpg",
                                                              height: 150,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: size.width * 0.4,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {
                                                        _captureAndSave();
                                                      },
                                                      icon: Icon(Icons.copy),
                                                      label: Text(
                                                        "บันทึกรูปภาพ",
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            kButtonColor,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 12,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : selectedPay == "cash"
                                          ? Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  const SizedBox(height: 12),

                                                  Text(
                                                    "ที แอนด์ ซี",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                      letterSpacing: 2,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  // 🔢 เลขบัญชี
                                                  Text(
                                                    "174-136-047-7",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                          ClipboardData(
                                                            text: "1741360477",
                                                          ),
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
                                                      label: Text(
                                                        "คัดลอกเลขบัญชี",
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            kButtonColor,
                                                        foregroundColor:
                                                            Colors.white,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 12,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox.shrink(),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          // เพิ่มความสูงหน่อยเพื่อให้มีที่วาง Tab
                                          width: size.width * 1,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              _image != null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child: Image.file(
                                                          _image!,
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        child: Image.asset(
                                                          "assets/images/pngtree-image-upload-icon-photo-upload-icon-png-image_2047546.jpg",
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: SizedBox(
                                                  width: size.width * 0.4,
                                                  child: ElevatedButton.icon(
                                                    onPressed: _pickImage,
                                                    icon: const Icon(
                                                      Icons.upload_file,
                                                    ),
                                                    label: const Text(
                                                      "อัพโหลดสลิป",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.green,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 12,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: size.width * 0.4,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () async {
                                                      if (_image == null) {
                                                        await showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialogYes(
                                                                title:
                                                                    'แจ้งเตือน',
                                                                description:
                                                                    'กรุณาอัพโหลดสลิป',
                                                                pressYes: () {
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                },
                                                              ),
                                                        );
                                                      } else {
                                                        try {
                                                          await ProductApi.paymentSilp(
                                                            quotation_id:
                                                                orderData!.id
                                                                    .toString(),
                                                            slip_image: _image,
                                                          );
                                                          final out = await showDialog(
                                                            barrierDismissible:
                                                                true,
                                                            context: context,
                                                            builder: (context) =>
                                                                SucesDialog(
                                                                  title:
                                                                      'แจ้งเตือน',
                                                                  description:
                                                                      'ชำระเงินสำเร็จ',
                                                                ),
                                                          );

                                                          if (out == true) {
                                                            Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        FirstPage(),
                                                              ),
                                                              (route) => false,
                                                            );
                                                          }
                                                        } on Exception catch (
                                                          e
                                                        ) {
                                                          if (!mounted) return;
                                                          await showDialog(
                                                            context: context,
                                                            builder: (context) =>
                                                                AlertDialogYes(
                                                                  title:
                                                                      'แจ้งเตือน',
                                                                  description:
                                                                      '$e',
                                                                  pressYes: () {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                  },
                                                                ),
                                                          );
                                                        }
                                                      }
                                                    },

                                                    label: Text("ชำระเงิน"),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          kButtonColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 12,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
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
                                )
                              : SizedBox.shrink(),
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
              status == true
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BillPage(orderData: orderData!),
                          ),
                        );
                      },
                      child: Icon(Icons.description, color: Colors.white),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
