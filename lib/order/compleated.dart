import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:t_and_c_mobile/addressPage.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/model/address.dart';
import 'package:t_and_c_mobile/model/distributors.dart';
import 'package:t_and_c_mobile/model/product.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/model/user.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/widget/buildRadioOption.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';

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
  // String? first_name;
  // String? last_name;
  File? _image;
  String? selectedAddress;
  int? distributor_id;
  int? address_id;
  // String? tel_no;
  final _controller = ScreenshotController();
  String? company_name;
  List<Address> addresslists = [];
  double vatRate = 0.07;
  double priceBeforeVat = 0.00;
  User? custommer;
  bool _wantPrint = false;

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

  // Future <void>testlist()async{
  //   inspect( widget.selectedItems);
  // }
  Future<void> getapi() async {
    try {
      LoadingDialog.open(context);
      custommer = await ProductApi.getUser();
      if (custommer?.customer == null) {
        await context.read<ProductController>().getlistdistributors();
        print("custommer เป็น null");
      } else {
        addresslists = await ProductApi.getAddressbyid(
          distributor_id: custommer!.customer!.id,
        );
        distributor_id = custommer!.customer!.id;
        if (addresslists.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("กรุณาเพิ่มที่อยู่ในระบบ")));
        } else {
          address_id = addresslists[0].id;
        }
      }
      setState(() {});
      // custommer = await ProductApi.getUser();

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

  Future<void> calculateVat() async {
    priceBeforeVat = widget.totalPrice! / (1 + vatRate);
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getapi();
      await calculateVat();
      // await testlist();
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
                              custommer?.customer == null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "เลือกลูกค้า",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        SizedBox(height: 10),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: size.width * 0.78,
                                          ), // กำหนดความกว้าง
                                          child: DropdownButtonFormField<Distributors>(
                                            isExpanded: true,
                                            dropdownColor: Colors.white,
                                            decoration: InputDecoration(
                                              labelText: "เลือลูกค้า",
                                              labelStyle: TextStyle(
                                                color: kbgM,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: kButtonColor,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: kButtonColor,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: kButtonColor,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            items: distributors.map((
                                              distributor,
                                            ) {
                                              return DropdownMenuItem<
                                                Distributors
                                              >(
                                                value: distributor,
                                                child: Text(
                                                  distributor.company_name ??
                                                      "", // ✅ ใช้ distributor
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) async {
                                              if (value != null) {
                                                print("ID: ${value.id}");
                                                print(
                                                  "Company Name: ${value.company_name}",
                                                );
                                                distributor_id = value.id;
                                                company_name =
                                                    value.company_name ?? "";
                                                final addresslist =
                                                    await ProductApi.getAddressbyid(
                                                      distributor_id:
                                                          distributor_id!,
                                                    );
                                                addresslists = addresslist;
                                                if (addresslists.isNotEmpty) {
                                                  address_id =
                                                      addresslists[0].id;
                                                  print(
                                                    "address_id คือ ${address_id}",
                                                  );
                                                }

                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                              addresslists.isEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ที่ต้องจัดส่ง",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        Container(
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
                                            "ไม่พบที่อยู่",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ที่ต้องจัดส่ง",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        GestureDetector(
                                          onTap: () async {
                                            final out = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressPage(
                                                      address: addresslists,
                                                    ),
                                              ),
                                            );
                                            if (out != null) {
                                              setState(() {
                                                address_id = out["addressid"];
                                                selectedAddress =
                                                    out["full_th_address"];
                                                print(
                                                  "address_id คือ ${address_id}",
                                                );
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: kButtonColor,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: selectedAddress == null
                                                ? Text(
                                                    addresslists[0]
                                                            .full_th_address ??
                                                        "",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  )
                                                : Text(
                                                    "$selectedAddress",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
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
                                "${custommer?.first_name ?? ""} ${custommer?.last_name ?? ""}",
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
                                custommer?.tel_no ?? "-",
                                style: TextStyle(color: kButtonColor),
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
                                                        "สี ",

                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget
                                                            .selectedItems![index]
                                                            .color,
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
                        selectedPay == "qrcode"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ContainerHeader(
                                      size: size,
                                      text: 'จ่ายผ่านQrcode ธนาคาร',
                                    ),
                                    Text(
                                      "บัญชีQrcode ธนาคาร ธนาคาร",
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
                                        label: Text("บันทึกรูปภาพ"),
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
                              )
                            : selectedPay == "cash"
                            ? Padding(
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

                                     SizedBox(height: 12),
Text(
                                                    "ที แอนด์ ซี",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
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
                                            ClipboardData(text: "1741360477"),
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
                              )
                            : selectedPay == "credit"
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 🏦 ชื่อธนาคาร
                                    ContainerHeader(
                                      size: size,
                                      text: 'จ่ายผ่านเครดิต',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "เครดิตปัจจุบันมีอยู่  ${formatNumber(custommer?.customer?.current_credit_used ?? "0")}/${formatNumber(custommer?.customer?.credit_limit ?? "0")}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: kButtonColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                selectedPay == "credit"
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // เพิ่มความสูงหน่อยเพื่อให้มีที่วาง Tab
                          width: size.width * 1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              _image != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _image!,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          "assets/images/pngtree-image-upload-icon-photo-upload-icon-png-image_2047546.jpg",
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: size.width * 0.4,
                                  child: ElevatedButton.icon(
                                    onPressed: _pickImage,
                                    icon: const Icon(Icons.upload_file),
                                    label: const Text("อัพโหลดสลิป"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
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
                          "ราคาก่อน vat",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          " ฿ ${formatNumber(priceBeforeVat)} ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kButtonColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ราคารวม vat",
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
                        if (addresslists.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("กรุณาเพิ่มที่อยู่ในระบบ")),
                          );
                        } else {
                          if (addresslists.isEmpty) {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialogYes(
                                title: 'แจ้งเตือน',
                                description: 'กรุณาเลือกที่อยู่',
                                pressYes: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          } else {
                            if (selectedPay == "credit") {
                              final out = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialogYesNo(
                                  title: 'แจ้งเตือน',
                                  description:
                                      'คุณต้องการส่งไปยังที่หมาย\n"${selectedAddress ?? addresslists[0].full_th_address ?? ""}" \n หรือไม่',
                                ),
                              );

                              if (out == true) {
                                try {
                                  List<Product> productModel = [];
                                  for (
                                    var i = 0;
                                    i < widget.selectedItems.length;
                                    i++
                                  ) {
                                    final item = widget.selectedItems[i];

                                    // วนซ้อนเพื่อเข้าถึง warehouse_skus ทุกตัวของ item นั้น ๆ
                                    for (
                                      var j = 0;
                                      j < item.warehouse_skus.length;
                                      j++
                                    ) {
                                      final sku = item.warehouse_skus[j];

                                      productModel.add(
                                        Product(
                                          item.product_id ?? "",
                                          item.nameTh,
                                          item.sku,
                                          sku.product_sku_id.toString(),
                                          item.price,
                                          sku.warehouse_id.toString(),
                                          item.quantity.toString(),
                                        ),
                                      );
                                    }
                                  }
                                  // inspect(productModel);
                                  await ProductApi.createOrder(
                                    distributor_id: custommer!.customer == null
                                        ? distributor_id.toString()
                                        : custommer!.customer!.id.toString(),
                                    qo_date: formatDate(DateTime.now()),
                                    total_qty: totalQuantity.toString(),
                                    total_cost_ex_vat: priceBeforeVat
                                        .toString(),
                                    total_vat_amount: widget.totalPrice
                                        .toString(),
                                    grand_total: widget.totalPrice.toString(),
                                    products: productModel,
                                    address_id: address_id.toString(),
                                    slip_image: _image,
                                    payment_method: '$selectedPay',
                                    total_cost_inc_vat: widget.totalPrice
                                        .toString(),
                                    is_print: '$_wantPrint',
                                  );

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
                                      MaterialPageRoute(
                                        builder: (context) => FirstPage(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } on Exception catch (e) {
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
                            } else {
                              if (_image == null) {
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialogYes(
                                    title: 'แจ้งเตือน',
                                    description: 'กรุณาอัพโหลดสลิป',
                                    pressYes: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              } else {
                                final out = await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialogYesNo(
                                    title: 'แจ้งเตือน',
                                    description:
                                        'คุณต้องการส่งไปยังที่หมาย\n"${selectedAddress ?? addresslists[0].full_th_address ?? ""}" \n หรือไม่',
                                  ),
                                );

                                if (out == true) {
                                  try {
                                    List<Product> productModel = [];
                                    for (
                                      var i = 0;
                                      i < widget.selectedItems.length;
                                      i++
                                    ) {
                                      final item = widget.selectedItems[i];

                                      // วนซ้อนเพื่อเข้าถึง warehouse_skus ทุกตัวของ item นั้น ๆ
                                      for (
                                        var j = 0;
                                        j < item.warehouse_skus.length;
                                        j++
                                      ) {
                                        final sku = item.warehouse_skus[j];

                                        productModel.add(
                                          Product(
                                            item.product_id ?? "",
                                            item.nameTh,
                                            item.sku,
                                            sku.product_sku_id.toString(),
                                            item.price,
                                            sku.warehouse_id.toString(),
                                            item.quantity.toString(),
                                          ),
                                        );
                                      }
                                    }
                                    print(
                                      convert.jsonEncode(
                                        productModel
                                            .map((p) => p.toJson())
                                            .toList(),
                                      ),
                                    );
                                    await ProductApi.createOrder(
                                      distributor_id:
                                          custommer!.customer == null
                                          ? distributor_id.toString()
                                          : custommer!.customer!.id.toString(),
                                      qo_date: formatDate(DateTime.now()),
                                      total_qty: totalQuantity.toString(),
                                      total_cost_ex_vat: priceBeforeVat
                                          .toString(),
                                      total_vat_amount: widget.totalPrice
                                          .toString(),
                                      grand_total: widget.totalPrice.toString(),
                                      products: productModel,
                                      address_id: address_id.toString(),
                                      slip_image: _image,
                                      payment_method: '$selectedPay',
                                      total_cost_inc_vat: widget.totalPrice
                                          .toString(),
                                      is_print: '$_wantPrint',
                                    );

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
                                        MaterialPageRoute(
                                          builder: (context) => FirstPage(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  } on Exception catch (e) {
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
                              }
                            }
                          }
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
