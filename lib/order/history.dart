import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/order/compleated.dart';
import 'package:t_and_c_mobile/order/orderDetail.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';

import 'package:t_and_c_mobile/widget/field.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';

class History extends StatefulWidget {
  History({super.key});
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final TextEditingController search = TextEditingController();
  List<Order> listOrders = [];

  Future<void> getapi() async {
    try {
      LoadingDialog.open(context);
      // context.read<ProductController>().getOrderList;
      final listOrder = await ProductApi.getOrderList();

      setState(() {
        listOrders = listOrder;
      });
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
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        final orderlist = controller.orderlist;
        return Scaffold(
          backgroundColor: kbgH,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kButtonColor,

            actions: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("assets/icons/Notification.png", scale: 15),
              ),
            ],
            centerTitle: true,
            title: Text(
              "ประวัติการสั่งซื้อ",
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
                      color: const Color.fromARGB(255, 241, 241, 241),
                      border: Border.all(color: kButtonColor),
                    ),
                    width: double.infinity,
                    height: size.height * 0.05,
                    child: TextFormField(
                      controller: search,
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                        prefixIcon: Image.asset(
                          "assets/icons/Search.png",
                          scale: 20,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Search here ...",
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'IBMPlexSansThai',
                          color: kbgM,
                        ),
                      ),
                      // onChanged: filterProducts,
                    ),
                  ),
                ),
                Column(
                  children: List.generate(
                    listOrders.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Orderdetail(
                              
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Order # ",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ), // สีปกติ
                                            ),
                                            TextSpan(
                                              text: listOrders[index].qo_code,
                                              style: const TextStyle(
                                                color: kButtonColor,
                                                fontWeight: FontWeight.bold
                                              ), // สีที่ต้องการ
                                            ),
                                          ],
                                        ),
                                      ),

                                      Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: ktextColr,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        // width: size.width * 0.7,
                                        height: size.height * 0.06,
                                        child: Center(
                                          child: Text(
                                            "สถานะ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("วันที่สั่งซื้อ"),
                                      Text(
                                        "${listOrders[index].qo_date}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: kButtonColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
