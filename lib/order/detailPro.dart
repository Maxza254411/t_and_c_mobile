import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/compleated.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/povider/favoriteProvider.dart';
import 'package:t_and_c_mobile/widget/buildRadioOption.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';

class Detailpro extends StatefulWidget {
  Detailpro({
    super.key,
    this.productId,
    required this.proName,
    required this.proPice,
    required this.detail,
    this.color,
    this.image,
    required this.proNameTh,
    this.sameproduct,
    this.sku,
  });

  String? productId;
  String proName;
  String proPice;
  String detail;
  List<Colorp?>? color;
  List<ProductTyp?>? sameproduct;
  String? image;
  String? proNameTh;
  String?sku;

  @override
  State<Detailpro> createState() => _DetailproState();
}

class _DetailproState extends State<Detailpro> {
  final GlobalKey _cartIconKey = GlobalKey(); // สำหรับ badge + animation
  final GlobalKey _btnKey = GlobalKey(); // สำหรับ animation
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentIndex = 0;
  String? selectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.color != null && widget.color!.isNotEmpty) {
      selectedColor = widget.color![0]?.name_en ?? "";
    }
  }

  void _goToPage(int index) {
    // ✅ เช็คก่อนว่า controller attach แล้วหรือยัง
    if (_controller.ready) {
      _controller.animateToPage(index);
    } else {
      debugPrint("CarouselSlider ยังไม่พร้อม");
    }
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
                  fit: BoxFit.cover,
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
            widget.sameproduct != null
                ? Column(
                    children: [
                      CarouselSlider.builder(
                        carouselController: _controller,
                        itemCount: widget.sameproduct!.length,
                        itemBuilder: (context, index, realIndex) {
                          return widget.sameproduct![index]?.image_url != null
                              ? Container(
                                  margin: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        widget.sameproduct![index]!.image_url ??
                                            "",
                                      ),

                                      fit: BoxFit.cover,
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
                            });
                          },
                        ),
                      ),
                      // SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: widget.sameproduct!.asMap().entries.map((entry) {
                      //     return Container(
                      //       width: 12,
                      //       height: 12,
                      //       margin: const EdgeInsets.symmetric(horizontal: 4),
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: _currentIndex == entry.key
                      //             ? Colors.blueAccent
                      //             : Colors.grey,
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
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
                      widget.proName,
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
                      widget.proNameTh ?? "-",
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
                      widget.sku ?? "-",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 5),

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
                    child: Text(
                      "฿ ${widget.proPice}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Consumer<FavoriteProvider>(
                    builder: (context, favProvider, child) {
                      final currentProduct = Shoping(
                        sku:widget.sku,
                        sameproduct: widget.sameproduct,
                        image: widget.image,
                        productId: widget.productId,
                        name: widget.proName,
                        price: widget.proPice,
                        detail: widget.detail,
                        colors: widget.color,
                        color: selectedColor ?? "",
                        nameTh: widget.proNameTh ?? "",
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
            if (widget.color != null && widget.color!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal, 
                      child: Row(
                        children: widget.color!.map((colorItem) {
                          if (colorItem?.name_en == null ||
                              colorItem!.name_en!.isEmpty) {
                            return  SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              width: size.width * 0.4,
                              child: BuildRadioOption(
                                title: colorItem.name_en!,
                                value: colorItem.name_en!,
                                groupValue: selectedColor,
                                onChanged: (val) {
                                  setState(() {
                                    selectedColor = val;
                                  });
                    
                                  // หา index ของสีที่เลือก
                                  final index = widget.color!.indexWhere(
                                    (c) => c?.name_en == val,
                                  );
                    
                                  if (index != -1 &&
                                      index < widget.sameproduct!.length) {
                                    _controller.animateToPage(
                                      index,
                                      duration: const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        }).toList(),
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
          padding: const EdgeInsets.all(8.0),
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
                      if (selectedColor == null || selectedColor!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("กรุณาเลือกสีสินค้า")),
                        );
                        return;
                      }
                      final shoping = Shoping(
                           sku:widget.sku,
                        image: widget.image,
                        name: widget.proName,
                        price: widget.proPice,
                        detail: widget.detail,
                        color: selectedColor!,
                        nameTh: widget.proNameTh ?? "",
                      );
                      Provider.of<CartProvider>(
                        context,
                        listen: false,
                      ).addItem(shoping);
                      _runAddToCartAnimation();
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
                      if (selectedColor == null || selectedColor!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("กรุณาเลือกสีสินค้า")),
                        );
                        return;
                      }
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
                          int quantity = 1;
                          int totalPriceBottom = 0;
                          return StatefulBuilder(
                            builder: (BuildContext context, StateSetter setState) {
                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          // width: size.width * 1,
                                          // height: size.height * 0.15,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.white,
                                              ),
                                              height: size.height * 0.15,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                        child:
                                                            widget.image == null
                                                            ? Image.asset(
                                                                "assets/images/NoImage.jpg",
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Image.network(
                                                                widget.image!,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                      ),
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
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
                                                      padding:
                                                          const EdgeInsets.all(
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
                                                            style:
                                                                const TextStyle(
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
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              // แสดงราคาฟอร์แมต
                                                              Text(
                                                                "฿ ${widget.proPice}",
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  8.0,
                                                                ),
                                                            child: Row(
                                                              children: [
                                                                // ลดจำนวน
                                                                InkWell(
                                                                  onTap: () async {
                                                                    if (quantity >
                                                                        1) {
                                                                      setState(
                                                                        () {
                                                                          quantity--;
                                                                        },
                                                                      );
                                                                    } else {
                                                                      debugPrint(
                                                                        "ต้องการลบสินค้า",
                                                                      );
                                                                    }
                                                                  },
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          2.0,
                                                                        ),
                                                                    child: Image.asset(
                                                                      "assets/icons/minus.png",
                                                                      scale: 30,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "$quantity",
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                // เพิ่มจำนวน
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      quantity++;
                                                                    });
                                                                  },
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          2.0,
                                                                        ),
                                                                    child: Image.asset(
                                                                      "assets/icons/Regular.png",
                                                                      scale: 30,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "ราคารวม ฿ ",
                                                      style: TextStyle(
                                                        color: Colors
                                                            .black, // สีตัวอักษรปกติ
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),

                                                    TextSpan(
                                                      text: formatNumber(
                                                        totalPriceBottom =
                                                            (double.parse(
                                                                      widget
                                                                          .proPice
                                                                          .replaceAll(
                                                                            ',',
                                                                            '',
                                                                          ),
                                                                    ) *
                                                                    quantity)
                                                                .toInt(),
                                                      ),
                                                      style: TextStyle(
                                                        color: kButtonColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 55,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        kButtonColor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    if (widget.proPice !=
                                                        "0.00") {
                                                      final shoping = Shoping(
                                                        quantity: quantity,
                                                        image: widget.image,
                                                        name: widget.proName,
                                                        price: widget.proPice,
                                                        detail: widget.detail,
                                                        color:
                                                            selectedColor ?? "",
                                                        nameTh:
                                                            widget.proNameTh ??
                                                            "",
                                                      );
                                           

                                                      // รอให้ bottom sheet ปิดเสร็จแล้วค่อย push หน้าใหม่
                                                      await Future.delayed(
                                                        Duration(
                                                          milliseconds: 200,
                                                        ),
                                                      );

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => Compleated(
                                                            totalPrice: double.parse(
                                                              totalPriceBottom
                                                                  .toString()
                                                                  .replaceAll(
                                                                    ',',
                                                                    '',
                                                                  ),
                                                            ),
                                                            status: false,
                                                            selectedItems: [
                                                              shoping,
                                                            ],
                                                            slipe_status: false,
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
