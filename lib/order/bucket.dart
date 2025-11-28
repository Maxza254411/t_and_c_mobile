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
  List<TextEditingController> qtyControllers = [];
  List<Brands> allbands = [];
  bool hasPromoType4 = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getBrands();
      final cart = Provider.of<CartProvider>(context, listen: false);
      if (allbands.isNotEmpty) {
        applyTierPromotionPerBrand(cart);
        setState(() {});
      }
    });
  }

  Future<void> getBrands() async {
    try {
      allbands = await ProductApi.listbrands();
    } catch (e) {
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
    if (price is String) return double.tryParse(price.replaceAll(',', '')) ?? 0;
    if (price is num) return price.toDouble();
    return 0;
  }

  String formatNumber(double number) {
    return NumberFormat("#,##0.00").format(number);
  }

  // ---------------------------------------------------------
  // APPLY TIER AND OTHER PROMOTIONS
  // ---------------------------------------------------------
  void applyTierPromotionPerBrand(CartProvider cart) {
    for (var brand in allbands) {
      final brandName = brand.name ?? "";

      final brandCount = cart.items
          .where((item) => item.namebrand == brandName)
          .fold<int>(0, (sum, item) => sum + item.quantity);

      for (var product in cart.items.where((i) => i.namebrand == brandName)) {
        double basePrice = parsePrice(product.base_price ?? product.price);
        double finalPrice = basePrice;

        bool hasPromo2 = false;
        bool hasOtherPromoApplied = false; // <-- เช็คว่ามีโปรอื่นทับ

        if (product.promotion != null && product.promotion!.isNotEmpty) {
          for (var promo in product.promotion!) {
            // -----------------------------
            // Case 1: Tier Promotion (ID = 2)
            // -----------------------------
            if (promo.promotion_id == 2) {
              hasPromo2 = true;

              for (var tier in promo.tiers) {
                if (brandCount >= (tier.min_qty ?? 0) &&
                    brandCount <= (tier.max_qty ?? 999999)) {
                  finalPrice = tier.price_per_unit!.toDouble();
                  hasOtherPromoApplied = true; // โปรอื่นใช้แล้ว
                  break;
                }
              }
            }
            // -----------------------------
            // Case 2: No tier but has other promo
            // -----------------------------
            else if (!hasPromo2) {
              if (promo.fixed_price != null && promo.fixed_price! > 0) {
                finalPrice = promo.fixed_price!.toDouble();
                hasOtherPromoApplied = true; // โปรอื่นใช้แล้ว
              }
            }
            // -----------------------------
            // Case 4: Promotion type 4
            // -----------------------------
            if (promo.promotion_id == 4) {
              // ถ้าไม่มีโปรอื่นถูกใช้ → ให้เป็น true
              hasPromoType4 = !hasOtherPromoApplied;
            }
          }
        }

        // Case 3: No promotion at all → finalPrice = basePrice (already set)

        product.price_per_unit = finalPrice.toInt();
      }
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

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final size = MediaQuery.of(context).size;

    while (qtyControllers.length < cart.items.length) {
      qtyControllers.add(TextEditingController());
    }
    for (int i = 0; i < cart.items.length; i++) {
      qtyControllers[i].text = cart.items[i].quantity.toString();
    }

    while (checked.length < cart.items.length) {
      checked.add(false);
    }

    double totalPrice = calculateTotalPrice(cart);
    double originalTotal = calculateOriginalTotal(cart);
    double discountAmount = calculateDiscount(cart);

    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        backgroundColor: kButtonColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: Colors.white),
        ),
        title: Row(
          children: [
            Image.asset("assets/icons/BucketIcon.png", scale: 15),
            SizedBox(width: 10),
            Text(
              "สินค้าในตะกร้า",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // -------------------------------------------------
      // ★★ SHOW PRODUCT COUNT PER BRAND HERE ★★
      // -------------------------------------------------
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kButtonColor, // สีปุ่ม
                    ),
                    child: InkWell(
                      onTap: () {
                        final cart = Provider.of<CartProvider>(
                          context,
                          listen: false,
                        );

                        // ถ้าไม่ใช่ทั้งหมดติ๊ก → ติ๊กทั้งหมด, ถ้าติ๊กทั้งหมดแล้ว → ยกเลิกทั้งหมด
                        bool allChecked = checked.every((c) => c);
                        setState(() {
                          for (int i = 0; i < checked.length; i++) {
                            checked[i] = !allChecked;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              checked.every((c) => c)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "เลือกสินค้าทั้งหมด",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final product = cart.items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          // height: size.height * 0.32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: kButtonColor,
                                value: checked[index],
                                onChanged: (v) {
                                  checked[index] = v!;
                                  setState(() {});
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

                              SizedBox(width: 10),

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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "สี ${product.color}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "SKU: ${product.sku}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          if (hasPromoType4) ...[
                                            // โปรประเภท 4 → แสดงราคาเต็มเท่านั้น
                                            Text(
                                              "฿ ${formatNumber(parsePrice(product.base_price))}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ] else if (product.promotion !=
                                                  null &&
                                              product
                                                  .promotion!
                                                  .isNotEmpty) ...[
                                            // แสดงราคาโปรโมชั่น + ราคาเต็มขีดฆ่า
                                            Text(
                                              "฿ ${formatNumber(parsePrice(product.price_per_unit ?? product.base_price))}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.red,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "฿ ${formatNumber(parsePrice(product.base_price))}",
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ] else ...[
                                            // ไม่มีโปรโมชั่น → แสดงราคาเต็ม
                                            Text(
                                              "฿ ${formatNumber(parsePrice(product.base_price))}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),

                                      Text("${product.namebrand}"),

                                      SizedBox(height: 6),

                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              if (product.quantity > 1) {
                                                product.quantity--;
                                                qtyControllers[index].text =
                                                    product.quantity.toString();

                                                applyTierPromotionPerBrand(
                                                  cart,
                                                );
                                                setState(() {});
                                              } else {
                                                final out = await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialogYesNo(
                                                        title: "แจ้งเตือน",
                                                        description:
                                                            "ต้องการลบสินค้านี้ไหม?",
                                                      ),
                                                );
                                                if (out == true) {
                                                  cart.removeItem(product);
                                                  setState(() {});
                                                }
                                              }
                                            },
                                            child: Icon(
                                              Icons.remove,
                                              color: kbgf,
                                            ),
                                          ),

                                          SizedBox(width: 8),

                                          SizedBox(
                                            width: 50,
                                            height: 30,
                                            child: TextField(
                                              controller: qtyControllers[index],
                                              textAlign: TextAlign.center,
                                              keyboardType:
                                                  TextInputType.number,
                                              onSubmitted: (value) {
                                                int qty =
                                                    int.tryParse(value) ?? 1;

                                                if (qty <= 0) qty = 1;

                                                product.quantity = qty;
                                                qtyControllers[index].text = qty
                                                    .toString();

                                                applyTierPromotionPerBrand(
                                                  cart,
                                                );
                                                setState(() {});
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: 4,
                                                    ),
                                              ),
                                            ),
                                          ),

                                          SizedBox(width: 8),

                                          InkWell(
                                            onTap: () {
                                              product.quantity++;
                                              qtyControllers[index].text =
                                                  product.quantity.toString();
                                              applyTierPromotionPerBrand(cart);
                                              setState(() {});
                                            },
                                            child: Image.asset(
                                              "assets/icons/Regular.png",
                                              scale: 30,
                                            ),
                                          ),

                                          SizedBox(width: 10),

                                          InkWell(
                                            onTap: () async {
                                              final out = await showDialog<bool>(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialogYesNo(
                                                      title: "แจ้งเตือน",
                                                      description:
                                                          "ต้องการลบสินค้านี้ไหม?",
                                                    ),
                                              );
                                              if (out == true) {
                                                cart.removeItem(product);
                                                setState(() {});
                                              }
                                            },
                                            child: Image.asset(
                                              "assets/icons/Trash.png",
                                              scale: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),

                                      // ของแถม //
                                      // if (hasPromoType4 == true)
                                      Column(
                                        children: List.generate(product.promotion!.length, (
                                          index,
                                        ) {
                                          final promo =
                                              product.promotion![index];

                                          // เช็คว่าเป็นโปรโมชันของแถม (id = 4)
                                          if (promo.promotion_id == 4) {
                                            // ถ้า free_item_rules เป็น list ก็ต้อง loop ซ้ำ
                                            return Column(
                                              children: List.generate(promo.free_item_rules!.length, (
                                                index2,
                                              ) {
                                                final rule = promo
                                                    .free_item_rules![index2];

                                                // เงื่อนไขจำนวนซื้อ >= buy_qty
                                                if (product.quantity >=
                                                    rule.buy_qty!) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[100],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          rule.free_sku_image_path==null
                                                          ?Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  8.0,
                                                                ),
                                                            child: Image.asset(
                                                              "assets/images/NoImage.jpg",
                                                              width: 60,
                                                              height: 60,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                          :
                       
                                                          // รูปของแถม
                                                         Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  8.0,
                                                                ),
                                                            child: Image.network(
                                                              rule.free_sku_image_path ??
                                                                  "",
                                                              width: 60, 
                                                              height: 60,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),

                                                          // ข้อมูลของแถม
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    rule.free_product_name_en ??
                                                                        "",
                                                                    style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  const Text(
                                                                    "ของแถม",
                                                                    style: TextStyle(
                                                                      color: Colors
                                                                          .orange,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "จำนวน: ${rule.free_qty} ชิ้น",
                                                                  ),
                                                                  Text(
                                                                    "SKU: ${rule.free_sku_code}",
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }

                                                // ถ้าซื้อไม่ถึงก็ไม่โชว์
                                                return const SizedBox.shrink();
                                              }),
                                            );
                                          }

                                          // ไม่ใช่โปรโมชัน id 4 → ไม่โชว์
                                          return const SizedBox.shrink();
                                        }),
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
                                .fold<int>(
                                  0,
                                  (sum, item) => sum + item.quantity,
                                );

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    brandName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          rowSummary(
                            "ราคาก่อนลด",
                            "฿ ${formatNumber(originalTotal)}",
                          ),
                          rowSummary(
                            "ส่วนลด",
                            "฿ ${formatNumber(discountAmount)}",
                          ),
                          rowSummary(
                            "จำนวนสินค้า",
                            "${((cart.items.fold<int>(0, (sum, item) => sum + item.quantity).toString()))} ชิ้น",
                          ),
                          Divider(),
                          rowSummary(
                            "ราคารวม",
                            "฿ ${formatNumber(totalPrice)}",
                            bold: true,
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              final selectedItems = <Shoping>[];
                              for (int i = 0; i < cart.items.length; i++) {
                                if (checked[i])
                                  selectedItems.add(cart.items[i]);
                              }
                              //  inspect(selectedItems);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Compleated(
                                    hasPromoType4: hasPromoType4,
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
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: kButtonColor,
                              ),
                              child: Center(
                                child: Text(
                                  "ถัดไป",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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

  Widget rowSummary(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
