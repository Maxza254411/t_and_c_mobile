import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/order/compleated.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';

class Bucket extends StatefulWidget {
  Bucket({super.key});

  @override
  State<Bucket> createState() => _BucketState();
}

class _BucketState extends State<Bucket> {
  List<bool> checked = [];
  List<int> quantities = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cart = Provider.of<CartProvider>(context);
    checked = List.generate(cart.items.length, (_) => false);
    quantities = List.generate(cart.items.length, (_) => 1);
  }

  double calculateTotalPrice(CartProvider cart) {
    double total = 0;
    for (int i = 0; i < cart.items.length; i++) {
      if (checked[i]) {
        total += parsePrice(cart.items[i].price) * cart.items[i].quantity;
      }
    }
    return total;
  }

  double parsePrice(dynamic price) {
    if (price is String) {
      return double.tryParse(price.replaceAll(',', '')) ?? 0;
    } else if (price is num) {
      return price.toDouble();
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;

    double totalPrice = calculateTotalPrice(cart);

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
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset("assets/icons/BucketIcon.png", scale: 15),
            ),
            SizedBox(width: 10),
            Text(
              "สินค้าในตะกร้า",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text(
                "ไม่พบสินค้าในตะกร้า",
                style: TextStyle(
                  color: kbgM,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final product = cart.items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          height: size.height * 0.15,
                          child: Row(
                            children: [
                              // Checkbox
                              Checkbox(
                                activeColor: kButtonColor,
                                value: checked[index],
                                onChanged: (value) {
                                  setState(() {
                                    checked[index] = value!;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Image.asset("assets/images/NoImage.jpg"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 1,
                                  height: size.height * 0.08,
                                  color: kButtonColor,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "สี ${product.color}"
                                        ,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // แสดงราคาฟอร์แมต
                                          Text("${product.price} บาท"),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                // ลดจำนวน
                                                InkWell(
                                                  onTap: () async {
                                                    if (product.quantity > 1) {
                                                      setState(() {
                                                        product.quantity--;
                                                      });
                                                    } else {
                                                      final out =
                                                          await showDialog<bool>(
                                                            barrierDismissible:
                                                                true,
                                                            context: context,
                                                            builder: (context) =>
                                                                AlertDialogYesNo(
                                                                  description:
                                                                      'ต้องการลบสินค้ารายการนี้หรือไม่',
                                                                  title:
                                                                      'แจ้งเตือน',
                                                                ),
                                                          );
                                                      if (out == true) {
                                                        setState(() {
                                                          cart.removeItem(
                                                            product,
                                                          );
                                                          checked.removeAt(index);
                                                          quantities.removeAt(
                                                            index,
                                                          );
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                      2.0,
                                                    ),
                                                    child: Image.asset(
                                                      "assets/icons/minus.png",
                                                      scale: 30,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text("${product.quantity}"),
                                                SizedBox(width: 10),
                                                // เพิ่มจำนวน
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      product.quantity++;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                      2.0,
                                                    ),
                                                    child: Image.asset(
                                                      "assets/icons/Regular.png",
                                                      scale: 30,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // ปุ่มลบสินค้า
                                          InkWell(
                                            onTap: () async {
                                              final out = await showDialog<bool>(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialogYesNo(
                                                      description:
                                                          'ต้องการลบสินค้ารายการนี้หรือไม่',
                                                      title: 'แจ้งเตือน',
                                                    ),
                                              );
                                  
                                              if (out == true) {
                                                setState(() {
                                                  cart.removeItem(product);
                                                  checked.removeAt(index);
                                                  quantities.removeAt(index);
                                                });
                                              }
                                            },
                                            child: Image.asset(
                                              "assets/icons/Trash.png",
                                              scale: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // ราคารวม + ปุ่มถัดไป
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          height: size.height * 0.13,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ราคารวม"),
                                  Text("${(totalPrice)} บาท"),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (totalPrice > 0) {
                                  final selectedItems = <Shoping>[];
                                  for (int i = 0; i < cart.items.length; i++) {
                                    if (checked[i]) {
                                      selectedItems.add(cart.items[i]);
                                    }
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Compleated(
                                        totalPrice:totalPrice,
                                        status: false,
                                        selectedItems:
                                            selectedItems, // ส่งไปหน้า Compleated
                                      ),
                                    ),
                                  );
                                }
                              },

                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: totalPrice > 0 ? kButtonColor : kbgf,
                                  ),
                                  height: size.height * 0.05,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      "ถัดไป",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: totalPrice > 0
                                            ? kbgf
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
