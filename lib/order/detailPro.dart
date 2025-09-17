import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/colorp.dart';
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
  });

  String? productId;
  String proName;
  String proPice;
  String detail;
  List<Colorp?>? color;
  String? image;
  String? proNameTh;

  @override
  State<Detailpro> createState() => _DetailproState();
}

class _DetailproState extends State<Detailpro> {
  final GlobalKey _cartIconKey = GlobalKey(); // สำหรับ badge + animation
  final GlobalKey _btnKey = GlobalKey(); // สำหรับ animation

  String? selectedColor;

  @override
  void initState() {
    super.initState();
    if (widget.color != null && widget.color!.isNotEmpty) {
      selectedColor = widget.color![0]?.name_en ?? "";
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
            Center(
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
                      "Name-En",
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
                      "Name-TH",
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
                      "${widget.proPice} บาท",
                      style: TextStyle(fontSize: 14,),
                    ),
                  ),
                  Consumer<FavoriteProvider>(
                    builder: (context, favProvider, child) {
                      final currentProduct = Shoping(
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
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Wrap(
                        children: widget.color!.map((colorItem) {
                          if (colorItem?.name_en == null || colorItem!.name_en!.isEmpty) {
                            return SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: size.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ปุ่มเพิ่มในตะกร้า
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    key: _btnKey,
                    width: size.width * 0.45,
                    height: size.height * 0.08,
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
                // ปุ่มสั่งซื้อ
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: size.width * 0.4,
                    height: size.height * 0.08,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: kButtonColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (widget.proPice != "0.00") {
                          final shoping = Shoping(
                            image: widget.image,
                            name: widget.proName,
                            price: widget.proPice,
                            detail: widget.detail,
                            color: selectedColor ?? "",
                            nameTh: widget.proNameTh ?? "",
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Compleated(
                                totalPrice: double.parse(widget.proPice),
                                status: false,
                                selectedItems: [shoping],
                                slipe_status: false,
                              ),
                            ),
                          );
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialogYes(
                              title: 'แจ้งเตือน',
                              description:
                                  'ไม่สามารถทำรายการได้ \n เพราะราคามีค่าเป็น 0.00 บาท',
                              pressYes: () => Navigator.pop(context),
                            ),
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
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
