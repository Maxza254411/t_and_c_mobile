import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;

import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/order.dart';
import 'package:t_and_c_mobile/order/orderDetail.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final TextEditingController search = TextEditingController();
  List<Order> listOrders = [];
  List<Order> filteredOrders = [];

  String selectedDateFilter = "all";
  DateTime? selectedCustomDate;

  Future<void> getapi() async {
    try {
      LoadingDialog.open(context);
      final listOrder = await ProductApi.getOrderList();

      setState(() {
        listOrders = listOrder;
        filteredOrders = listOrder;
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

  void filterOrders() {
    List<Order> temp = List.from(listOrders);

    // 🔍 กรองจาก Search
    if (search.text.isNotEmpty) {
      temp = temp
          .where((order) =>
              order.qo_code!.toLowerCase().contains(search.text.toLowerCase()))
          .toList();
    }

    final now = DateTime.now();

    if (selectedDateFilter == "today") {
      temp = temp.where((order) {
        final orderDate = DateTime.parse(order.qo_date!);
        return orderDate.year == now.year &&
            orderDate.month == now.month &&
            orderDate.day == now.day;
      }).toList();
    } else if (selectedDateFilter == "week") {
      final weekAgo = now.subtract(const Duration(days: 7));
      temp = temp.where((order) {
        final orderDate = DateTime.parse(order.qo_date!);
        return orderDate.isAfter(weekAgo) &&
            orderDate.isBefore(now.add(const Duration(days: 1)));
      }).toList();
    } else if (selectedDateFilter == "month") {
      temp = temp.where((order) {
        final orderDate = DateTime.parse(order.qo_date!);
        return orderDate.year == now.year && orderDate.month == now.month;
      }).toList();
    } else if (selectedDateFilter == "custom" && selectedCustomDate != null) {
      temp = temp.where((order) {
        final orderDate = DateTime.parse(order.qo_date!);
        return orderDate.year == selectedCustomDate!.year &&
            orderDate.month == selectedCustomDate!.month &&
            orderDate.day == selectedCustomDate!.day;
      }).toList();
    }

    setState(() {
      filteredOrders = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: kbgH,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kButtonColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/icons/Notification.png", scale: 15),
              ),
            ],
            centerTitle: true,
            title: const Text(
              "ประวัติการสั่งซื้อ",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 🔎 Search + Filter Dropdown + DatePicker
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: search,
                          style: const TextStyle(fontSize: 22),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Image.asset(
                              "assets/icons/Search.png",
                              scale: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade400),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kButtonColor, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: kButtonColor, width: 2),
                            ),
                            hintText: "ค้นหาเลขคำสั่งซื้อ ...",
                            hintStyle: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'IBMPlexSansThai',
                              color: kbgM,
                            ),
                          ),
                          onChanged: (val) => filterOrders(),
                        ),
                      ),
                     SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                          child: Container(
                          height: size.height * 0.07,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                               Colors.white,
                            border: Border.all(color: kButtonColor,width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                focusColor: Colors.white,
                                dropdownColor: Colors.white,
                                value: selectedDateFilter,
                                isExpanded: true,
                                items:  [
                                  DropdownMenuItem(
                                      value: "all", child: Text("ทั้งหมด")),
                                  DropdownMenuItem(
                                      value: "today", child: Text("วันนี้")),
                                  DropdownMenuItem(
                                      value: "week", child: Text("สัปดาห์นี้")),
                                  DropdownMenuItem(
                                      value: "month", child: Text("เดือนนี้")),
                                  DropdownMenuItem(
                                      value: "custom", child: Text("เลือกวันที่")),
                                ],
                                onChanged: (value) async {
                                  if (value == "custom") {
                                    picker.DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(2020, 1, 1),
                                      maxTime: DateTime(2100, 12, 31),
                                      currentTime: DateTime.now(),
                                      locale: picker.LocaleType.th,
                                      onConfirm: (date) {
                                        setState(() {
                                          selectedDateFilter = "custom";
                                          selectedCustomDate = date;
                                        });
                                        filterOrders();
                                      },
                                    );
                                  } else {
                                    setState(() {
                                      selectedCustomDate = null;
                                      selectedDateFilter = value!;
                                      filterOrders();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 📋 แสดงรายการ Order
                Column(
                  children: List.generate(
                    filteredOrders.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // print(  filteredOrders[index]
                          //                           .status??"");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Orderdetail(
                                orderData: filteredOrders[index],
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
                                              ),
                                            ),
                                            TextSpan(
                                              text: filteredOrders[index]
                                                  .qo_code,
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
                                          color:
                                          
                                           filteredOrders[index]
                                                    .status=="doc_to_peak"
                                          ?Colors.amber
                                          : kbgM,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        height: size.height * 0.05,
                                        child: Center(
                                          child: Text(
                                            filteredOrders[index]
                                                    .status_name ??
                                                "",
                                            style: const TextStyle(
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
                                      const Text("วันที่สั่งซื้อ"),
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
                                filteredOrders[index].payment_method=="credit"
                               ?Padding(
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
                                )
                                : SizedBox.shrink()
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
