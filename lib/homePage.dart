import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/detailPro.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/category/catagory.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController search = TextEditingController();
  int _currentIndex = 0;
  String? idPro;
  String? namePro;
  String? first_name;
  String? last_name;
  final CarouselSliderController _controller = CarouselSliderController();

  void _goToPage(int index) {
    // ✅ เช็คก่อนว่า controller attach แล้วหรือยัง
    if (_controller.ready) {
      _controller.animateToPage(index);
    } else {
      debugPrint("CarouselSlider ยังไม่พร้อม");
    }
  }

  Future<void> getapi() async {
    try {
      LoadingDialog.open(context);
      await context.read<ProductController>().getproductlist();
      await context.read<ProductController>().getproduct();
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

  Future<void> getpreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    first_name = prefs.getString('first_name');
    last_name = prefs.getString('last_name');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getapi();
      await getpreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<CartProvider>(context);
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        final productTyp = controller.productTyp;
        final product = controller.product;

        return Scaffold(
          backgroundColor: kbgH,
          appBar: AppBar(
            backgroundColor: kButtonColor,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Bucket()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset("assets/icons/Buy.png", scale: 15),

                      if (cart.items.isNotEmpty) // แสดง badge เมื่อมีสินค้า
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/icons/Notification.png", scale: 15),
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  // getapi();
                },
                child: Image.asset("assets/icons/Vector.png", scale: 15),
              ),
            ),
            title: Text(
              "${first_name} ${last_name}",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: InputTextFormField(
                //     hintText: "Search here ...",
                //     controller: search,
                //     size: size,
                //     heights: size.height * 0.05,
                //     imagestatus: true,
                //     images: "assets/icons/Search.png",
                //     whatfield: false,
                //     width: double.infinity,
                //   ),
                // ),
                Column(
                  children: [
                    CarouselSlider.builder(
                      carouselController: _controller,
                      itemCount: imgList.length,
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: AssetImage(imgList[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: size.height * 0.2,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _goToPage(entry.key);
                            });
                          },
                          child: Container(
                            width: 12,
                            height: 12,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == entry.key
                                  ? Colors.blueAccent
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.02),
                      Text(
                        "ประเภทสินค้า",
                        style: TextStyle(
                          fontSize: 14,
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
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size.width * 0.78,
                        ), // กำหนดความกว้าง
                        child: DropdownButtonFormField<ProductTyp>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: "เลือกสินค้า",
                            labelStyle: TextStyle(color: kbgM),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: kButtonColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: kButtonColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: kButtonColor,
                                width: 2,
                              ),
                            ),
                          ),
                          items: productTyp.map((product) {
                            return DropdownMenuItem<ProductTyp>(
                              value: product, // 👈 ส่ง object ทั้งตัว
                              child: Text(
                                product.name_en ?? "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              print("ID: ${value.id}");
                              print("Name: ${value.name_en}");
                              idPro = value.id.toString();
                              namePro = value.name_en ?? "";
                            }
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Catagory(id: idPro!, title: namePro ?? ""),
                            ),
                          );
                        },
                        child: Container(
                          width: size.width * 0.15,
                          height: size.height * 0.05,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),

                            color: kButtonColor,
                          ),
                          child: Center(
                            child: Text(
                              "ค้นหา",
                              style: TextStyle(
                                fontSize: 12,
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

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: size.width * 0.02),
                      Text(
                        "สินค้าแนะนำ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kButtonColor,
                        ),
                      ),
                    ],
                  ),
                ),
                product.isEmpty
                 ? SizedBox.shrink()
                 : SizedBox(
                  height: size.height * 0.5,
                  width: size.width * 1,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: 4,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final products = product[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                spreadRadius: 2,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // รูปสินค้า
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.asset(
                                    "assets/images/NoImage.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              // ข้อมูลสินค้า
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      products.product?.name_th ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatNumber(
                                        products.product?.srp_inc_vat ?? "0",
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // ปุ่มสั่งซื้อ
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kButtonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Detailpro(
                                                proName:
                                                    products.product?.name_en ??
                                                    "",
                                                proPice: formatNumber(
                                                  products
                                                          .product
                                                          ?.srp_inc_vat ??
                                                      "0",
                                                ),
                                                detail: "",
                                                color:
                                                    products.color?.name_en ??
                                                    "",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "สั่งซื้อ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
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
                        );
                      },
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
