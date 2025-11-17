import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/login.dart';
import 'package:t_and_c_mobile/model/brands.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/order/compleated.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';

class Bucket extends StatefulWidget {
  Bucket({super.key});

  @override
  State<Bucket> createState() => _BucketState();
}

class _BucketState extends State<Bucket> {
  List<bool> checked = [];
  List<int> quantities = [];
  List<TextEditingController> qtyControllers = [];
  List<Brands> allbands = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cart = Provider.of<CartProvider>(context);

    checked = List.generate(cart.items.length, (_) => false);
    quantities = List.generate(cart.items.length, (_) => 1);

    // init controllers
    while (qtyControllers.length < cart.items.length) {
      qtyControllers.add(TextEditingController());
    }
    for (int i = 0; i < cart.items.length; i++) {
      qtyControllers[i].text = cart.items[i].quantity.toString();
    }

    // เช็คโปรโมชั่นทุกสินค้าในตะกร้า ตอนเข้าหน้า
    for (var product in cart.items) {
      checkPromotionForProduct(product);
    }

    // Apply Tier Promotion per Brand
    applyTierPromotionPerBrand(cart);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getapi();
    });
  }

  @override
  void dispose() {
    for (var c in qtyControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> getapi() async {
    try {
      allbands = await ProductApi.listbrands();
      setState(() {});
    } on Exception catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '$e' == "Unauthenticated"
              ? 'การเข้าสู่ระบบหมดอายุ'
              : '$e',
          pressYes: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
              (route) => false,
            );
          },
        ),
      );
    }
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

  // ฟังก์ชันเช็คโปรโมชั่นเฉพาะสินค้า
  void checkPromotionForProduct(Shoping product) {
    if (product.promotion == null || product.promotion!.isEmpty) return;

    double basePrice = parsePrice(product.price);
    double newPrice = basePrice;
    double newPriceFromOtherPromo = basePrice;

    bool tierMatched = false;

    for (var promo in product.promotion!) {
      // โปร percent / fixed
      if (promo.promotion_id == 1 || promo.promotion_id == 3) {
        if (promo.percent != null && promo.percent! > 0) {
          newPriceFromOtherPromo =
              basePrice - (basePrice * (promo.percent! / 100));
        }
        if (promo.fixed_price != null && promo.fixed_price! > 0) {
          newPriceFromOtherPromo = promo.fixed_price!.toDouble();
        }
      }
      // โปร 2 tier
      else if (promo.promotion_id == 2) {
        tierMatched = false;
        for (var tier in promo.tiers) {
          if (product.quantity >= (tier.min_qty ?? 0) &&
              product.quantity <= (tier.max_qty ?? double.infinity)) {
            newPrice = (tier.price_per_unit ?? newPriceFromOtherPromo)
                .toDouble();
            tierMatched = true;
            break;
          }
        }

        if (!tierMatched) {
          newPrice = newPriceFromOtherPromo;
        }

        product.price_per_unit = newPrice.toInt();
      }
    }
  }

  // ฟังก์ชันใหม่: Apply Tier Promotion ตามจำนวนรวมของแบรนด์
  void applyTierPromotionPerBrand(CartProvider cart) {
    for (var brand in allbands) {
      final brandName = brand.name ?? "";

      // รวมจำนวนสินค้าของแบรนด์
      final brandCount = cart.items
          .where((item) => item.namebrand == brandName)
          .fold<int>(0, (sum, item) => sum + item.quantity);

      // วนทุกสินค้าในแบรนด์นั้น
      for (var product in cart.items.where((item) => item.namebrand == brandName)) {
        if (product.promotion == null) continue;

        double basePrice = parsePrice(product.price);
        double newPrice = basePrice;
        double newPriceFromOtherPromo = basePrice;

        for (var promo in product.promotion!) {
          // percent/fixed
          if (promo.promotion_id == 1 || promo.promotion_id == 3) {
            if (promo.percent != null && promo.percent! > 0) {
              newPriceFromOtherPromo =
                  basePrice - (basePrice * (promo.percent! / 100));
            }
            if (promo.fixed_price != null && promo.fixed_price! > 0) {
              newPriceFromOtherPromo = promo.fixed_price!.toDouble();
            }
          }
          // tier 2
          else if (promo.promotion_id == 2) {
            bool tierMatched = false;
            for (var tier in promo.tiers) {
              if (brandCount >= (tier.min_qty ?? 0) &&
                  brandCount <= (tier.max_qty ?? double.infinity)) {
                newPrice = (tier.price_per_unit ?? newPriceFromOtherPromo)
                    .toDouble();
                tierMatched = true;
                break;
              }
            }
            if (!tierMatched) {
              newPrice = newPriceFromOtherPromo;
            }

            product.price_per_unit = newPrice.toInt();
          }
        }
      }
    }
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
                        qtyControllers.add(TextEditingController(
                            text: product.quantity.toString()));
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          height: size.height * 0.18,
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
                                      product.fixed_price != null
                                          ? Row(
                                              children: [
                                                product.price_per_unit == null
                                                    ? Text(
                                                        "฿ ${formatNumber(double.parse(product.fixed_price.toString()))}",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )
                                                    : Text(
                                                        "฿ ${formatNumber(double.parse(product.price_per_unit.toString()))}",
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                                Text(
                                                  "฿ ${formatNumber(double.parse(product.base_price.toString()))}",
                                                ),
                                              ],
                                            ),
                                      Text("${product.namebrand}"),
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
                                                    qtyControllers[index].text =
                                                        product.quantity.toString();
                                                  });
                                                  applyTierPromotionPerBrand(cart);
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
                                                      qtyControllers[index].text =
                                                          intValue.toString();
                                                      applyTierPromotionPerBrand(cart);
                                                    });
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 4),
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
                                                  qtyControllers[index].text =
                                                      product.quantity.toString();
                                                });
                                                applyTierPromotionPerBrand(cart);
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

                                            // ลบสินค้า
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

                // แสดงจำนวนสินค้าแยกตามแบรนด์
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Column(
                          children: List.generate(allbands.length, (index) {
                            final brandName = allbands[index].name ?? "";
                            final count = cart.items
                                .where((item) => item.namebrand == brandName)
                                .fold<int>(0, (sum, item) => sum + item.quantity);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(brandName),
                                  Text("จำนวน: $count ชิ้น"),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),

                // ราคาสรุป
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
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kButtonColor,
                              ),
                              height: size.height * 0.05,
                              child: Center(
                                child: Text(
                                  "ถัดไป",
                                  style: TextStyle(
                                    fontSize: 16,
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
              ],
            ),
    );
  }
}
