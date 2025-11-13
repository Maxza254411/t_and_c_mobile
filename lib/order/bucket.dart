import 'dart:developer';
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
  List<TextEditingController> qtyControllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cart = Provider.of<CartProvider>(context);

    checked = List.generate(cart.items.length, (_) => false);
    quantities = List.generate(cart.items.length, (_) => 1);

    while (qtyControllers.length < cart.items.length) {
      qtyControllers.add(TextEditingController());
    }
    for (int i = 0; i < cart.items.length; i++) {
      qtyControllers[i].text = cart.items[i].quantity.toString();
    }
  }

  @override
  void dispose() {
    for (var c in qtyControllers) {
      c.dispose();
    }
    super.dispose();
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

  String formatNumber(double number) {
    final formatter = NumberFormat("#,##0.00");
    return formatter.format(number);
  }

  void checkPromotionForProduct(Shoping product) {
    if (product.promotion == null || product.promotion!.isEmpty) return;

    for (var promo in product.promotion!) {
      if (promo.promotion_type == 2) {
        bool matched = false;
        for (var tier in promo.tiers) {
          if (product.quantity >= (tier.min_qty!) &&
              product.quantity <= (tier.max_qty!)) {
            setState(() {
              product.price_per_unit =
                  tier.price_per_unit ?? product.base_price!;
            });
            matched = true;
            break;
          }
        }
        if (!matched) {
          setState(() {
            product.base_price = product.base_price;
          });
        }
      }
    }
  }

  /// 🧮 ฟังก์ชันคำนวณยอดรวม ราคาก่อนลด หลังลด และส่วนลดทั้งหมด
  Map<String, double> calculateTotals(CartProvider cart) {
    double originalTotal = 0;
    double discountedTotal = 0;

    for (int i = 0; i < cart.items.length; i++) {
      if (checked[i]) {
        final product = cart.items[i];
        final qty = product.quantity;
        final original = product.fixed_price == 0
            ? parsePrice(product.base_price)
            : parsePrice(product.fixed_price);
        final discounted = parsePrice(
          product.price_per_unit ?? product.base_price,
        );
        originalTotal += original * qty;
        discountedTotal += discounted * qty;
      }
    }

    double discountAmount = originalTotal - discountedTotal;

    return {
      "original": originalTotal,
      "discounted": discountedTotal,
      "discount": discountAmount,
    };
  }

  Map<String, int> calculateBrandQty(CartProvider cart) {
    Map<String, int> brandCount = {"Anidary": 0, "Baseus": 0, "Alldocube": 0};

    for (int i = 0; i < cart.items.length; i++) {
      if (checked[i]) {
        final brand = cart.items[i].namebrand?.toString().trim() ?? "";
        final qty = cart.items[i].quantity;
        if (brandCount.containsKey(brand)) {
          brandCount[brand] = brandCount[brand]! + qty;
        }
      }
    }

    return brandCount;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;

    final totals = calculateTotals(cart);
    double originalTotal = totals["original"]!;
    double discountAmount = totals["discount"]!;
    double totalPrice = totals["discounted"]!;
    final brandQty = calculateBrandQty(cart);
    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
                      if (index >= checked.length) {
                        checked.add(false);
                        quantities.add(product.quantity);
                      }

                      qtyControllers[index].text = product.quantity.toString();

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          height: size.height * 0.16,
                          child: Row(
                            children: [
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
                                child: SizedBox(
                                  width: size.width * 0.2,
                                  height: size.height * 0.08,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: product.image == null
                                        ? Image.asset(
                                            "assets/images/NoImage.jpg",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            product.image!,
                                            fit: BoxFit.fitHeight,
                                          ),
                                  ),
                                ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        "สี ${product.color}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "SKU: ${product.sku}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      product.fixed_price != 0
                                          ? Row(
                                              children: [
                                                Text(
                                                  "฿ ${formatNumber(double.parse(product.fixed_price.toString()) )}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "฿ ${formatNumber(double.parse(product.base_price.toString()) )}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                // แสดงราคาฟอร์แมต
                                                Text(
                                                  "฿ ${formatNumber(double.parse(product.base_price.toString()))}",
                                                ),
                                              ],
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (product.quantity > 1) {
                                                  setState(() {
                                                    product.quantity--;
                                                  });
                                                  checkPromotionForProduct(
                                                    product,
                                                  );
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
                                                      cart.removeItem(product);
                                                      checked.removeAt(index);
                                                      quantities.removeAt(
                                                        index,
                                                      );
                                                      qtyControllers.removeAt(
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
                                            const SizedBox(width: 10),
                                            SizedBox(
                                              width: 50,
                                              height: 30,
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    qtyControllers[index],
                                                onSubmitted: (value) {
                                                  final intValue =
                                                      int.tryParse(value) ??
                                                      product.quantity;
                                                  if (intValue <= 0) {
                                                    showDialog<bool>(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialogYesNo(
                                                            title: 'แจ้งเตือน',
                                                            description:
                                                                'ต้องการลบสินค้ารายการนี้หรือไม่',
                                                          ),
                                                    ).then((out) {
                                                      if (out == true) {
                                                        setState(() {
                                                          cart.removeItem(
                                                            product,
                                                          );
                                                          checked.removeAt(
                                                            index,
                                                          );
                                                          quantities.removeAt(
                                                            index,
                                                          );
                                                          qtyControllers
                                                              .removeAt(index);
                                                        });
                                                      }
                                                    });
                                                  } else {
                                                    setState(() {
                                                      product.quantity =
                                                          intValue;
                                                      checkPromotionForProduct(
                                                        product,
                                                      );
                                                      qtyControllers[index]
                                                          .text = intValue
                                                          .toString();
                                                    });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  isDense: true,
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  product.quantity++;
                                                });
                                                checkPromotionForProduct(
                                                  product,
                                                );
                                                qtyControllers[index].text =
                                                    product.quantity.toString();
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
                                            const SizedBox(width: 10),
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
                                                    qtyControllers.removeAt(
                                                      index,
                                                    );
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
                          height: size.height * 0.18,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ราคาสินค้า"),
                                  Text("${formatNumber(originalTotal)} บาท"),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("ส่วนลดทั้งหมด"),
                                  Text(
                                    "${formatNumber(discountAmount)} บาท",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
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
                                  Text("ราคารวมทั้งหมด"),
                                  Text(
                                    "${formatNumber(totalPrice)} บาท",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                        totalPrice: totalPrice,
                                        status: false,
                                        selectedItems: selectedItems,
                                        slipe_status: false,
                                        discountAmount: discountAmount,
                                        originalTotal: originalTotal,
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
