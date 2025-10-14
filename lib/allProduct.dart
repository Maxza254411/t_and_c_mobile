import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/category/catagory.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/login.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';

class Allproduct extends StatefulWidget {
  Allproduct({super.key, required this.status, this.brandId});
  final String status;
  final int? brandId;

  @override
  State<Allproduct> createState() => _AllproductState();
}

class _AllproductState extends State<Allproduct> {
  final TextEditingController search = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String keyword = "";
  List<ProductTyp> producttypes = [];
  List<ProductTyp> filteredProducts = [];

  Future<void> getapi() async {
    try {
      LoadingDialog.open(context);
      if (widget.status == "product") {
        producttypes = await ProductApi.getproducttypes();
      } else {
        producttypes = await ProductApi.getproductypBybrandid(
          brandid: widget.brandId!,
        );
      }
      filteredProducts = producttypes; // ✅ กำหนดค่าเริ่มต้น
      setState(() {});
      LoadingDialog.close(context);
    } catch (e) {
      LoadingDialog.close(context);
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '$e',
          pressYes: () {
            Navigator.pop(context);
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => Loginpage()),
            //   (route) => false,
            // );
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
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    search.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void filterProducts(String value) {
    setState(() {
      keyword = value;
      filteredProducts = producttypes
          .where(
            (p) =>
                (p.name_en ?? "").toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  // ✅ แถบค้นหา
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.chevron_left,
                          color: kButtonColor,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
                          controller: search,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Image.asset(
                              "assets/icons/Search.png",
                              scale: 20,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: kButtonColor,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: kButtonColor,
                                width: 2,
                              ),
                            ),
                            hintText: "ค้นหาประเภทสินค้า...",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'IBMPlexSansThai',
                              color: kbgM,
                            ),
                          ),
                          onChanged: filterProducts,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ✅ แสดงรายการสินค้า
                  producttypes.isEmpty
                      ? Column(
                          children: [
                            SizedBox(height: size.height * 0.3),
                            Text(
                              "ไม่พบประเภทสินค้า",
                              style: TextStyle(
                                color: kbgM,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(product.name_en ?? ""),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Catagory(
                                          brandid: widget.brandId ?? 1,
                                          title: product.name_en ?? "",
                                          productTypid: product.id,
                                          statusPage:widget.status == "product"? "product":"brand"
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
