import 'dart:developer';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/tabletPage.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController search = TextEditingController();
  int _currentIndex = 0;
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
    // try {
    final testproduct = await context.read<ProductController>().getproductlist();
    inspect(testproduct);
    // } on Exception catch (e) {
    // if (!mounted) return;
    //  await showDialog(
    //     context: context,
    //     builder: (context) => AlertDialogYes(
    //       title: 'แจ้งเตือน',
    //       description: '$e',
    //       pressYes: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //   );
    // }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await getapi();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        backgroundColor: kButtonColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Buy.png", scale: 15),
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
              getapi();
            },
            child: Image.asset("assets/icons/Vector.png", scale: 15)),
        ),
        title: Text(
          "Admin Admin",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * 0.08,
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: kbgf),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputTextFormField(
                    hintText: "Search here ...",
                    controller: search,
                    size: size,
                    heights: size.height * 0.05,
                    imagestatus: true,
                    images: "assets/icons/Search.png", whatfield: false,
                  ),
                ),
              ],
            ),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TabletPage()));
                      },
                      child: Column(
                        children: [
                          Image.asset('assets/icons/TabGuoup.png', scale: 8),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            "แท็บเล็ต",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: kbgM,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Image.asset('assets/icons/eargroup.png', scale: 8),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "หูฟัง",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kbgM,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Image.asset('assets/icons/AccGroup.png', scale: 8),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "ACC",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kbgM,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Image.asset('assets/icons/PhoneGroup.png', scale: 8),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "โทรศัพท์",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kbgM,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: [
                        Image.asset('assets/icons/AllGroup.png', scale: 8),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "All",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kbgM,
                          ),
                        ),
                      ],
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
                    "สินค้าเเนะนำ",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: kButtonColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.5,
              width: size.width * 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
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
                                product["image"]!,
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
                                  product["title"]!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product["price"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // ปุ่มสั่งซื้อ
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {},
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
  }
}
