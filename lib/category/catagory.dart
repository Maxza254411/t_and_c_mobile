import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/order/detailPro.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class Catagory extends StatefulWidget {
  Catagory({super.key, required this.status, required this.id,required this.title});
  String status;
  String id;
  String title;
  @override
  State<Catagory> createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> {
  final TextEditingController search = TextEditingController();

  Future<void> getapi() async {
    try {
      final testproduct = await context
          .read<ProductController>()
          .getproductbyid(id: int.parse(widget.id), page: 1);
      print(widget.id);
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
    return Consumer<ProductController>(
       builder: (context, controller, child){
            final productbyid = controller.productbyid;
   return  Scaffold(
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
              child: Image.asset("assets/icons/Buy.png", scale: 15),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset("assets/icons/Notification.png", scale: 15),
            ),
          ],
          centerTitle: true,
          title: Text(
            "แท็บเล็ต",
            style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height * 0.08,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: kbgf),
                child: InputTextFormField(
                  hintText: "Search here ...",
                  controller: search,
                  size: size,
                  heights: size.height * 0.05,
                  imagestatus: true,
                  images: "assets/icons/Search.png",
                  whatfield: false,
                  width: double.infinity,
                ),
              ),
      
              SizedBox(
                height: size.height * 0.7,
                width: size.width * 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: productbyid.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final product = productbyid[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 2,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // รูปสินค้า
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: 
                                  product.product?.image_url==null
                               ? Image.asset(
                                 "assets/images/NoImage.jpg",
                                  fit: BoxFit.cover,
                                )
                                :Image.network(product.product!.image_url!),
                              ),
                            ),
                            // ข้อมูลสินค้า
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.product?.name_en??"",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                  "0.00",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // ปุ่มสั่งซื้อ
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: kButtonColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => Detailpro(
                                        //       proName: product["title"]!,
                                        //       proPice: product["price"]!,
                                        //       detail: product["detail"]!,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                      child: Text(
                                        "สั่งซื้อ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: kbgf,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
       }
    );
  }
}
