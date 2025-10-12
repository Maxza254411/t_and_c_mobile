import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/order/orderDetail.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';
class PendingPayments extends StatefulWidget {
   PendingPayments({super.key});

  @override
  State<PendingPayments> createState() => _PendingPaymentsState();
}

class _PendingPaymentsState extends State<PendingPayments> {
  List<Order> listOrders = [];
  List<Order> filteredOrders = [];
  Future<void> getapi() async {
  try {
    LoadingDialog.open(context);

    final listOrder = await ProductApi.getOrderList();

    // 🔹 กรองเฉพาะรายการที่ payment_method == "credit"
    final filteredCreditOrders = listOrder
        .where((order) => order.payment_method?.toLowerCase() == "credit")
        .toList();

    setState(() {
      listOrders = listOrder;             
      filteredOrders = filteredCreditOrders; 
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
    return  Scaffold(
          backgroundColor: kbgH,
          appBar: AppBar(
           iconTheme: IconThemeData(
              color: Colors.white
            ),
            automaticallyImplyLeading: true,
            backgroundColor: kButtonColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/icons/Notification.png", scale: 15),
              ),
            ],
            centerTitle: true,
            title: const Text(
              "ประวัติการชำระด้วยเครดิต",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
            
                Column(
                  children: List.generate(
                    filteredOrders.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  Orderdetail(orderData: filteredOrders[index], ),
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
                                              ),
                                            ),
                                            TextSpan(
                                              text: filteredOrders[index].qo_code,
                                              style: const TextStyle(
                                                color: kButtonColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: filteredOrders[index]
                                                    .status=="doc_to_peak"
                                          ?Colors.amber
                                          : kbgM,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        height: size.height * 0.05,
                                        child: Center(
                                          child: Text(
                                          filteredOrders[index].status_name??"",
                                            style:  TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
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
                                        "${filteredOrders[index].qo_date}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: kButtonColor,
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
                                     Text("วันที่ครบกำหนดชำระ"),
                                      Text(
                                        "${filteredOrders[index].qo_date}",
                                        style: const TextStyle(
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
  }
}