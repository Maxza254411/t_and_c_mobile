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

    // init checked & quantities
    checked = List.generate(cart.items.length, (_) => false);
    quantities = List.generate(cart.items.length, (_) => 1);

    // init controllers
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

  double calculateTotalPrice(CartProvider cart) {
    double total = 0;
    for (int i = 0; i < cart.items.length; i++) {
      if (checked[i]) {
        total +=
            parsePrice(cart.items[i].price_per_unit ?? cart.items[i].price) *
                cart.items[i].quantity;
      }
    }
    return total;
  }

  double calculateOriginalTotal(CartProvider cart) {
    double total = 0;
    for (int i = 0; i < cart.items.length; i++) {
      if (checked[i]) {
        total += parsePrice(cart.items[i].price) * cart.items[i].quantity;
      }
    }
    return total;
  }

  double calculateDiscount(CartProvider cart) {
    return calculateOriginalTotal(cart) - calculateTotalPrice(cart);
  }

  String formatNumber(double number) {
    final formatter = NumberFormat("#,##0.00");
    return formatter.format(number);
  }

  void checkPromotionForProduct(Shoping product) {
    if (product.promotion == null || product.promotion!.isEmpty) return;

    double basePrice = parsePrice(product.price);
    double newPrice = basePrice;
    double newPriceFromOtherPromo = basePrice;

    bool tierMatched = false;

    for (var promo in product.promotion!) {
      // โปร 1 หรือ 3
      if (promo.promotion_id == 1 || promo.promotion_id == 3) {
        if (promo.percent != null && promo.percent! > 0) {
          newPriceFromOtherPromo =
              basePrice - (basePrice * (promo.percent! / 100));
          log("🎯 โปร ${promo.promotion_id}: ลด ${promo.percent}% จาก $basePrice → $newPriceFromOtherPromo");
        }
        if (promo.fixed_price != null && promo.fixed_price! > 0) {
          newPriceFromOtherPromo = promo.fixed_price!.toDouble();
          log(
              "🎯 โปร ${promo.promotion_id}: ราคา fix จาก $basePrice → $newPriceFromOtherPromo");
        }
      }

      // โปร 2
      else if (promo.promotion_id == 2) {
        tierMatched = false;
        for (var tier in promo.tiers) {
          if (product.quantity >= (tier.min_qty ?? 0) &&
              product.quantity <= (tier.max_qty ?? double.infinity)) {
            newPrice = (tier.price_per_unit ?? newPriceFromOtherPromo).toDouble();
            tierMatched = true;
            log(
                "🎯 โปร 2: เข้า tier ${tier.min_qty}-${tier.max_qty} ราคา ${tier.price_per_unit}");
            break;
          }
        }

        if (!tierMatched) {
          newPrice = newPriceFromOtherPromo;
          log("ℹ️ โปร 2: ไม่เข้า tier → ใช้ราคาโปรอื่น $newPrice");
        }
         setState(() {
      product.price_per_unit 
      = newPrice.toInt();
      log("ราคาสุดท้ายของสินค้า: ${product.price_per_unit}");
    });
      }
    }

    setState(() {
      product.price_per_unit ;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;

    double totalPrice = calculateTotalPrice(cart);
    double originalTotal = calculateOriginalTotal(cart);
    double discountAmount = calculateDiscount(cart);

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
                                      product.fixed_price != 0 ||  product.fixed_price != null
                                          ? Row(
                                              children: [
                                                product.price_per_unit==null
                                               ? Text(
                                                  "฿ ${formatNumber(double.parse(product.fixed_price.toString()))}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )
                                                :Text(
                                                  "฿ ${formatNumber(double.parse( product.price_per_unit.toString()))}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                 SizedBox(width: 10),
                                                Text(
                                                  "฿ ${formatNumber(double.parse(product.base_price.toString()))}",
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
                                            // ลดจำนวน
                                            InkWell(
                                              onTap: () async {
                                                if (product.quantity > 1) {
                                                  setState(() {
                                                    product.quantity--;
                                                  });
                                                  checkPromotionForProduct(product);
                                                } else {
                                                  final out =
                                                      await showDialog<bool>(
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
                                                      qtyControllers.removeAt(index);
                                                    });
                                                  }
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Image.asset(
                                                  "assets/icons/minus.png",
                                                  scale: 30,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            // TextField
                                            SizedBox(
                                              width: 50,
                                              height: 30,
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: qtyControllers[index],
                                                onSubmitted: (value) {
                                                  final intValue =
                                                      int.tryParse(value) ?? product.quantity;
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
                                                          cart.removeItem(product);
                                                          checked.removeAt(index);
                                                          quantities.removeAt(index);
                                                          qtyControllers.removeAt(index);
                                                        });
                                                      }
                                                    });
                                                  } else {
                                                    setState(() {
                                                      product.quantity = intValue;
                                                      checkPromotionForProduct(product);
                                                      qtyControllers[index].text = intValue.toString();
                                                    });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(vertical: 4),
                                                  isDense: true,
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            // เพิ่มจำนวน
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  product.quantity++;
                                                });
                                                checkPromotionForProduct(product);
                                                qtyControllers[index].text = product.quantity.toString();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Image.asset(
                                                  "assets/icons/Regular.png",
                                                  scale: 30,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            // ถังขยะ
                                            InkWell(
                                              onTap: () async {
                                                final out = await showDialog<bool>(
                                                  barrierDismissible: true,
                                                  context: context,
                                                  builder: (context) => AlertDialogYesNo(
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
                                                    qtyControllers.removeAt(index);
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
                // สรุปยอด
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ราคาก่อนลด"),
                              Text("฿ ${formatNumber(originalTotal)}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("ส่วนลด"),
                              Text("฿ ${formatNumber(discountAmount)}"),
                            ],
                          ),
                          Divider(color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ราคารวม",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "฿ ${formatNumber(totalPrice)}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              // if (totalPrice > 0) {
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
                              // }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:  kButtonColor ,
                              ),
                              height: size.height * 0.05,
                              child: Center(
                                child: Text(
                                  "ถัดไป",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:   kbgf ,
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
              ],
            ),
    );
  }
}
