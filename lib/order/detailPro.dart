import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/NewProductModel/newdata.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/promotione.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/compleated.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/povider/favoriteProvider.dart';
import 'package:t_and_c_mobile/widget/buildRadioOption.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';

class Detailpro extends StatefulWidget {
  Detailpro({
    super.key,
    required this.productId,
    required this.proName,
    required this.proPice,
    this.color,
    this.image,
    required this.proNameTh,
    // this.sameproduct,
    required this.skulist,
    required this.skuid,
    required this.warehouse_skus,
    required this.namebrand,
    this.promotion,
    this.listimage,
    this.newdata,
  });

  String productId;
  String proName;
  String proPice;
  List<String?>? listimage;
  List<Colorp?>? color;
  // List<Data>? sameproduct;
  String? image;
  String? proNameTh;
  List<String?> skulist;
  List<int> skuid;
  List<Warehouse> warehouse_skus = [];
  String namebrand;
  List<Promotione>? promotion;
  Newdata? newdata;

  @override
  State<Detailpro> createState() => _DetailproState();
}

class _DetailproState extends State<Detailpro> {
  final GlobalKey _cartIconKey = GlobalKey(); // สำหรับ badge + animation
  final GlobalKey _btnKey = GlobalKey(); // สำหรับ animation
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  String? selectedColor;
  int? warehouse_skus;
  String? sku;
  int? skuid;
  String? image;
  int? price;
  int? pice_promotion;
  List<Promotione>? promotion;
  int? dilog_pice;
  int? dialog_promotion;
  double totalBeforeDiscount = 0;
  double totalAfterDiscount = 0;
  double discountAmount = 0;
  int quantity = 1;
  String? name_th;
  String? name_en;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await selectsku();
    });
  }

  // Future<void> testPromo() async {
  //   inspect(widget.promotion);
  // }

  Future<void> selectsku() async {
    // inspect(widget.promotion);
    sku = widget.newdata!.skus![0].sku;
    skuid = widget.newdata!.skus![0].product_sku_id;
    selectedColor = widget.newdata!.skus![0].color!.name_th;
    image = widget.newdata!.skus![0].image_url;
    if (widget.newdata!.skus![0].warehouse_skus!.isNotEmpty) {
      warehouse_skus =
          widget.newdata?.skus?[0].warehouse_skus?[0].available ?? 0;
    } else {
      warehouse_skus = 0;
    }
    price = widget.newdata!.skus![0].base_price;
    if (widget.newdata!.skus![0].promotions!.isNotEmpty) {
      if (widget.newdata!.skus![0].promotions?[0].promotion_id != 2) {
        pice_promotion = widget.newdata!.skus![0].promotions?[0].fixed_price;
      }
    } else {
      pice_promotion = 0;
    }

    promotion = widget.newdata?.skus?[0].promotions;
    name_th = widget.newdata?.name_th;
    name_en = widget.newdata?.name_en;

    setState(() {
      // print("ราคา ${promotion}");
      // inspect(promotion);
    });
  }

  void _goToPage(int index) {
    // ✅ เช็คก่อนว่า controller attach แล้วหรือยัง
    if (_controller.ready) {
      _controller.animateToPage(index);
    } else {
      debugPrint("CarouselSlider ยังไม่พร้อม");
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

  void checkPromotionForProduct(
    List<Promotione> promotion,
    int quantity,
    int prices,
    Function(double newPrice) onPriceCalculated, // ✅ เพิ่ม callback ส่งค่ากลับ
  ) {
    if (promotion.isEmpty) {
      onPriceCalculated(prices.toDouble());
      return;
    }

    double basePrice = parsePrice(prices);
    double newPrice = basePrice;
    double newPriceFromOtherPromo = basePrice;
    bool tierMatched = false;

    for (var promo in promotion) {
      if (promo.promotion_id == 1 || promo.promotion_id == 3) {
        if (promo.percent != null && promo.percent! > 0) {
          newPriceFromOtherPromo =
              basePrice - (basePrice * (promo.percent! / 100));
        }
        if (promo.fixed_price != null && promo.fixed_price! > 0) {
          newPriceFromOtherPromo = promo.fixed_price!.toDouble();
        }
      } else if (promo.promotion_id == 2) {
        tierMatched = false;
        for (var tier in promo.tiers) {
          if (quantity >= (tier.min_qty ?? 0) &&
              quantity <= (tier.max_qty ?? double.infinity)) {
            newPrice = (tier.price_per_unit ?? newPriceFromOtherPromo)
                .toDouble();
            tierMatched = true;
            break;
          }
        }
        if (!tierMatched) {
          newPrice = newPriceFromOtherPromo;
        }
      }
    }

    // ✅ ส่งราคาสุดท้ายกลับไปให้ส่วน UI ใช้งาน
    onPriceCalculated(newPrice);
  }

  void _runAddToCartAnimation() {
    final overlay = Overlay.of(context);
    final renderBoxBtn =
        _btnKey.currentContext!.findRenderObject() as RenderBox;
    final renderBoxCart =
        _cartIconKey.currentContext!.findRenderObject() as RenderBox;

    final start = renderBoxBtn.localToGlobal(Offset.zero);
    final end = renderBoxCart.localToGlobal(Offset.zero);

    final entry = OverlayEntry(
      builder: (context) {
        return TweenAnimationBuilder<Offset>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: start, end: end),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Positioned(left: value.dx, top: value.dy, child: child!);
          },
          child: widget.image != null
              ? Image.network(
                  widget.image!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  "assets/images/NoImage.jpg",
                  width: 40,
                  height: 40,
                  fit: BoxFit.fitHeight,
                ),
        );
      },
    );

    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 600), () {
      entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.proName,
          style: TextStyle(color: kbgM, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Bucket()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    key: _cartIconKey,
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset("assets/icons/BuyBack.png", scale: 15),
                      if (cart.items.isNotEmpty)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              "${cart.items.length}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            widget.newdata?.skus != null
                ? Column(
                    children: [
                      CarouselSlider.builder(
                        carouselController: _controller,
                        itemCount: widget.newdata?.skus?.length,
                        itemBuilder: (context, index, realIndex) {
                          return widget.newdata?.skus != null
                              ? Container(
                                  margin: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        widget
                                                .newdata
                                                ?.skus?[index]
                                                .image_url ??
                                            "",
                                      ),

                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/NoImage.jpg",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                        },
                        options: CarouselOptions(
                          height: size.height * 0.2,
                          enlargeCenterPage: false,
                          autoPlay: false,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          enableInfiniteScroll: false,
                          autoPlayAnimationDuration: const Duration(
                            milliseconds: 800,
                          ),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                              image = widget.newdata?.skus?[index].image_url;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: widget.image != null
                        ? Image.network(widget.image!)
                        : Image.asset("assets/images/NoImage.jpg"),
                  ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // ชิดด้านบน
                children: [
                  SizedBox(
                    width: 80, // กำหนดความกว้างของ Label "Name-En"
                    child: Text(
                      "Name-En:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      name_en??'',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // ชิดด้านบน
                children: [
                  SizedBox(
                    width: 80, // กำหนดความกว้างของ Label "Name-En"
                    child: Text(
                      "Name-TH:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      name_th??"",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // ชิดด้านบน
                children: [
                  SizedBox(
                    width: 80, // กำหนดความกว้างของ Label "Name-En"
                    child: Text(
                      "ชื่อแบร์น :",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.namebrand,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // ชิดด้านบน
                children: [
                  SizedBox(
                    width: 80, // กำหนดความกว้างของ Label "Name-En"
                    child: Text(
                      "SKU:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${sku}",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5),

            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // ชิดด้านบน
                    children: [
                      SizedBox(
                        width: 80, // กำหนดความกว้างของ Label "Name-En"
                        child: Text(
                          "ในคลัง:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      widget.warehouse_skus.isNotEmpty
                          ? Expanded(
  child: Text(
    "${(warehouse_skus ?? 0)} ชิ้น",
    style: TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
  ),
)
                          : Expanded(
                              child: Text(
                                "สินค้าหมด",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80, // กำหนดความกว้างของ Label "Name-En"
                    child: Text(
                      "ราคา",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: pice_promotion != 0
                        ? Row(
                            children: [
                              Text(
                                "฿ ${formatNumber(pice_promotion ?? 0)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "฿ ${formatNumber(price ?? 0)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              // แสดงราคาฟอร์แมต
                              Text("฿ ${formatNumber(price)}"),
                            ],
                          ),
                  ),
                  Consumer<FavoriteProvider>(
                    builder: (context, favProvider, child) {
                      final currentProduct = Shoping(
                        namebrand: widget.namebrand,
                        image: widget.image,
                        product_id: widget.productId,
                        name: widget.proName,
                        price: widget.proPice,
                        colors: widget.color,
                        color: selectedColor ?? "",
                        nameTh: widget.proNameTh ?? "",
                        warehouse_skus: widget.warehouse_skus,
                        promotion: promotion,
                        skulist: widget.skulist,
                        skuidlist: widget.skuid,
                        newData: widget.newdata,
                      );
                      final isFav = favProvider.isFavorite(currentProduct);
                      return GestureDetector(
                        onTap: () => favProvider.toggleFavorite(currentProduct),
                        child: Image.asset(
                          isFav
                              ? "assets/icons/HertOn.png"
                              : "assets/icons/HertOff.png",
                          scale: 10,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (widget.newdata!.skus != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: widget.newdata!.skus!.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final colorItem = entry.value;
                            if (colorItem.color!.name_th == null) {
                              return SizedBox.shrink();
                            }
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: SizedBox(
                                width: size.width * 0.4,
                                child: BuildRadioOption(
                                  title: colorItem.color!.name_th!,
                                  value: colorItem.color!.name_th!,
                                  groupValue: selectedColor,
                                  onChanged: (val) {
                                    
                                    setState(() {
                                      inspect(widget.newdata);
                                      selectedColor = val;

                                      // เปลี่ยน sku ตาม index ของสีที่เลือก
                                      if (index <
                                          widget.newdata!.skus!.length) {
                                        name_th = widget.newdata!.name_th;
                                        name_en = widget.newdata!.name_en;
                                        sku = widget.newdata!.skus![index].sku;
                                        skuid = widget
                                            .newdata!
                                            .skus![index]
                                            .product_sku_id;
                                        warehouse_skus = widget
                                            .newdata!
                                            .skus![index]
                                            .warehouse_skus![0]
                                            .available;
                                        price = widget
                                            .newdata!
                                            .skus![index]
                                            .base_price;
                                      }                                   
                                      if (index <
                                          widget.newdata!.skus!.length) {
                                        if (widget
                                            .newdata!
                                            .skus![index]
                                            .promotions!
                                            .isNotEmpty ) {
                                          if (widget
                                                  .newdata!
                                                  .skus![index]
                                                  .promotions?[0]
                                                  .promotion_id !=
                                              2) {
                                            pice_promotion = widget
                                                .newdata!
                                                .skus![index]
                                                .promotions?[0]
                                                .fixed_price;
                                          }
                                        } else {
                                          pice_promotion = 0;
                                        }
                                        // if (widget
                                        //         .newdata!
                                        //         .skus![index]
                                        //         .promotions!.isNotEmpty) {
                                        //     if (widget
                                        //         .newdata!
                                        //         .skus![index]
                                        //         .promotions?[0]
                                        //         .promotion_id !=
                                        //     2) {
                                        //   pice_promotion = widget
                                        //       .newdata!
                                        //       .skus![index]
                                        //       .promotions?[0]
                                        //       .fixed_price;
                                        // }else{
                                        //   pice_promotion=0;
                                        // }
                                        // }

                                        promotion = widget
                                            .newdata
                                            ?.skus?[index]
                                            .promotions;
                                      }
                                    });

                                    // ถ้ามี PageView ให้เลื่อนตามสี
                                    _controller.animateToPage(
                                      index,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  typ: 'color',
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ปุ่มเพิ่มในตะกร้า
              Expanded(
                child: SizedBox(
                  key: _btnKey,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (warehouse_skus == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("ไม่พบสินค้าในคลัง")),
                        );
                      } else {
                        if (selectedColor == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("กรุณาเลือกสีสินค้า")),
                          );
                          return;
                        }
                        final shoping = Shoping(
                          namebrand: widget.namebrand,
                          product_id: widget.productId,
                          sku: sku,
                          skuid: skuid,
                          image: image,
                          name: widget.proName,
                          price: price.toString(),
                          color: selectedColor,
                          nameTh: widget.proNameTh ?? "",
                          warehouse_skus: widget.warehouse_skus,
                          promotion: promotion,
                          newData: widget.newdata,
                          fixed_price: pice_promotion??0,
                          base_price: price??0,
                          price_per_unit: pice_promotion == 0
                              ? price
                              : pice_promotion,
                        );
                        Provider.of<CartProvider>(
                          context,
                          listen: false,
                        ).addItem(shoping);
                        _runAddToCartAnimation();
                      }
                    },
                    child: Text(
                      "เพิ่มในตะกร้า",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kbgf,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              // ปุ่มสั่งซื้อ
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: kButtonColor, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (warehouse_skus == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("ไม่พบสินค้าในคลัง")),
                        );
                      } else {
                        if (selectedColor == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("กรุณาเลือกสีสินค้า")),
                          );
                          return;
                        }
                        setState(() {
                          dilog_pice = price;
                          dialog_promotion = pice_promotion;

                          checkPromotionForProduct(
                            promotion!,
                            quantity,
                            dilog_pice!,
                            (newPrice) {
                              totalBeforeDiscount =
                                  double.parse(dilog_pice.toString()) *
                                  quantity;
                              totalAfterDiscount = newPrice * quantity;
                              discountAmount =
                                  totalBeforeDiscount - totalAfterDiscount;
                              // dialog_promotion = newPrice.toInt();
                            },
                          );
                          // print(
                          //   "${totalBeforeDiscount},${totalAfterDiscount},${discountAmount}",
                          // );
                        });
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          isScrollControlled: true, // ให้เลื่อนขึ้นลงได้
                          builder: (BuildContext context) {
                            // int quantity = 1;

                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: Colors.white,
                                                ),
                                                height: size.height * 0.18,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 2,
                                                      ),
                                                      child: SizedBox(
                                                        width:
                                                            size.width *
                                                            0.2, // กำหนดความกว้าง
                                                        height:
                                                            size.height *
                                                            0.08, // กำหนดความสูง
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ), // ถ้าอยากให้มุมโค้ง
                                                          child: image == null
                                                              ? Image.asset(
                                                                  "assets/images/NoImage.jpg",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.network(
                                                                  image!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                        ),
                                                      ),
                                                    ),

                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Container(
                                                        width: 1,
                                                        height:
                                                            size.height * 0.08,
                                                        color: kButtonColor,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              widget.proName,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "สี $selectedColor",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            Text(
                                                              "SKU: $sku",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            pice_promotion != 0
                                                                ? Row(
                                                                    children: [
                                                                      Text(
                                                                        "฿ ${formatNumber(dialog_promotion ?? 0)}",
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        "฿ ${formatNumber(dilog_pice ?? 0)}",
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.grey,
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Row(
                                                                    children: [
                                                                      // แสดงราคาฟอร์แมต
                                                                      Text(
                                                                        "฿ ${formatNumber(dilog_pice)}",
                                                                      ),
                                                                    ],
                                                                  ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Row(
                                                                children: [
                                                                  // ลดจำนวน
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      if (quantity >
                                                                          1) {
                                                                        setState(() {
                                                                          quantity--;
                                                                          dialog_promotion ==
                                                                                  null
                                                                              ? checkPromotionForProduct(
                                                                                  promotion!,
                                                                                  quantity,
                                                                                  dilog_pice!,
                                                                                  (
                                                                                    newPrice,
                                                                                  ) {
                                                                                    totalBeforeDiscount =
                                                                                        double.parse(
                                                                                          dilog_pice.toString(),
                                                                                        ) *
                                                                                        quantity;
                                                                                    totalAfterDiscount =
                                                                                        newPrice *
                                                                                        quantity;
                                                                                    discountAmount =
                                                                                        totalBeforeDiscount -
                                                                                        totalAfterDiscount;
                                                                                    dialog_promotion = newPrice.toInt();
                                                                                  },
                                                                                )
                                                                              : checkPromotionForProduct(
                                                                                  promotion!,
                                                                                  quantity,
                                                                                  dialog_promotion!,
                                                                                  (
                                                                                    newPrice,
                                                                                  ) {
                                                                                    totalBeforeDiscount =
                                                                                        double.parse(
                                                                                          dilog_pice.toString(),
                                                                                        ) *
                                                                                        quantity;
                                                                                    totalAfterDiscount =
                                                                                        newPrice *
                                                                                        quantity;
                                                                                    discountAmount =
                                                                                        totalBeforeDiscount -
                                                                                        totalAfterDiscount;
                                                                                    dialog_promotion = newPrice.toInt();
                                                                                  },
                                                                                );
                                                                        });
                                                                      } else {
                                                                        debugPrint(
                                                                          "ต้องการลบสินค้า",
                                                                        );
                                                                      }
                                                                    },
                                                                    child: Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                            2.0,
                                                                          ),
                                                                      child: Image.asset(
                                                                        "assets/icons/minus.png",
                                                                        scale:
                                                                            30,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),

                                                                  // ✅ ช่องกรอกจำนวน
                                                                  SizedBox(
                                                                    width: 50,
                                                                    height: 30,
                                                                    child: TextField(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      controller: TextEditingController(
                                                                        text: quantity
                                                                            .toString(),
                                                                      ),
                                                                      onChanged: (value) {
                                                                        final intValue =
                                                                            int.tryParse(
                                                                              value,
                                                                            );
                                                                        if (intValue !=
                                                                                null &&
                                                                            intValue >
                                                                                0) {
                                                                          setState(
                                                                            () {
                                                                              quantity = intValue;
                                                                            },
                                                                          );
                                                                        }
                                                                      },
                                                                      decoration: InputDecoration(
                                                                        contentPadding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              4,
                                                                        ),
                                                                        isDense:
                                                                            true,
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),

                                                                  // เพิ่มจำนวน
                                                                  InkWell(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        quantity++;
                                                                     
                                                                             checkPromotionForProduct(
                                                                                promotion!,
                                                                                quantity,
                                                                                dilog_pice!,
                                                                                (
                                                                                  newPrice,
                                                                                ) {
                                                                                  totalBeforeDiscount =
                                                                                      double.parse(
                                                                                        dilog_pice.toString(),
                                                                                      ) *
                                                                                      quantity;
                                                                                  totalAfterDiscount =
                                                                                      newPrice *
                                                                                      quantity;
                                                                                  discountAmount =
                                                                                      totalBeforeDiscount -
                                                                                      totalAfterDiscount;
                                                                                  dialog_promotion = newPrice.toInt();
                                                                                },
                                                                              );
                                                                          
                                                                      });
                                                                    },
                                                                    child: Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                            2.0,
                                                                          ),
                                                                      child: Image.asset(
                                                                        "assets/icons/Regular.png",
                                                                        scale:
                                                                            30,
                                                                      ),
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
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // ✅ สรุปยอดรวมทั้งหมด
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // 🔹 ราคารวมก่อนส่วนลด
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            "ราคารวม",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            "฿ ${formatNumber(totalBeforeDiscount)}",
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),

                                                      // 🔹 ส่วนลด
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Text(
                                                            "ส่วนลด",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            "฿ ${formatNumber(discountAmount)}",
                                                            style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 6),

                                                      // 🔹 ยอดหลังส่วนลด
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 4,
                                                            ),
                                                        decoration:
                                                            BoxDecoration(
                                                              border: Border(
                                                                top: BorderSide(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300,
                                                                ),
                                                              ),
                                                            ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              "ยอดหลังส่วนลด",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            Text(
                                                              "฿ ${formatNumber(totalAfterDiscount)}",
                                                              style: TextStyle(
                                                                color:
                                                                    kButtonColor,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                // ✅ ปุ่มสั่งซื้อ
                                                SizedBox(
                                                  height: 55,
                                                  width: 120,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          kButtonColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      elevation: 3,
                                                    ),
                                                    onPressed: () async {
                                                      if (dilog_pice != 0 ||
                                                          dialog_promotion !=
                                                              0) {
                                                        final shoping = Shoping(
                                                          skuid: skuid,
                                                          sku: sku,
                                                          product_id:
                                                              widget.productId,
                                                          quantity: quantity,
                                                          image: image,
                                                          name: widget.proName,
                                                          price: widget.proPice,
                                                          color:
                                                              selectedColor ??
                                                              "",
                                                          nameTh:
                                                              widget
                                                                  .proNameTh ??
                                                              "",
                                                          warehouse_skus: widget
                                                              .warehouse_skus,
                                                          fixed_price:
                                                              dialog_promotion,
                                                          base_price:
                                                              dilog_pice,
                                                        );

                                                        await Future.delayed(
                                                          const Duration(
                                                            milliseconds: 200,
                                                          ),
                                                        );

                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) => Compleated(
                                                              totalPrice:
                                                                  dialog_promotion ==
                                                                      null
                                                                  ? double.parse(
                                                                      dilog_pice
                                                                          .toString(),
                                                                    )
                                                                  : double.parse(
                                                                      dialog_promotion
                                                                          .toString(),
                                                                    ),
                                                              status: false,
                                                              selectedItems: [
                                                                shoping,
                                                              ],
                                                              slipe_status:
                                                                  false,
                                                              discountAmount:
                                                                  discountAmount,
                                                              originalTotal:
                                                                  (dilog_pice ??
                                                                      0) *
                                                                  quantity
                                                                      .toDouble(),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        await showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialogYes(
                                                                title:
                                                                    'แจ้งเตือน',
                                                                description:
                                                                    'ไม่สามารถทำรายการได้ \n เพราะราคามีค่าเป็น 0.00 บาท',
                                                                pressYes: () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                              ),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "สั่งซื้อ",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      "สั่งซื้อ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kButtonColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
