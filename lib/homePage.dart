import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_and_c_mobile/category/brandPage.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/brands.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/productTyp.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/nontification.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/detailPro.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/povider/favoriteProvider.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController search = TextEditingController();
  int _currentIndex = 0;
  String? idPro;
  String? namePro;
  String? first_name;
  String? last_name;
  String?email;
  int? userId;
  List<ProductTyp?> uniqueProducts = [];
  List<Brands> allbands = []; //เก็บข้อมูลเเบร์นทั้งหมด
  List<Brands> filteredBand = []; //กรองเเบร์น

  final CarouselSliderController _controller = CarouselSliderController();
  List<Data> product = [];

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
      // LoadingDialog.open(context);
      final listband = await ProductApi.listbrands();
      allbands = listband;
      // final producs = await ProductApi.getproductbyid(id: 1, page: 1);
      // product = producs;
      // uniqueProducts = product.map((e) => e.product).toSet().toList();

      // LoadingDialog.close(context);
    } on Exception catch (e) {
      // LoadingDialog.close(context);
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
    userId = prefs.getInt('userId');
      email  = prefs.getString('email');
  }

 void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      filteredBand = List.from(allbands);
    } else {
      filteredBand = allbands.where((item) {
        final name = item.name ?? "";
        return name.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    }
    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getpreferences();
      await getapi();
      filteredBand = List.from(allbands);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<CartProvider>(context);
    return Consumer<ProductController>(
      builder: (context, controller, child) {
        // final productTyp = controller.productTyp;
        final brands = controller.brands;
        return Scaffold(
          backgroundColor: kbgH,
          key: _scaffoldKey,
          drawer: Drawer(
            backgroundColor: Colors.white,
           child: ListView(
           padding: EdgeInsets.zero,
           children: [
            DrawerHeader(
              decoration: BoxDecoration(color: kButtonColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: kbgf,
                    radius: 30,
                    backgroundImage: AssetImage("assets/icons/Vector.png"),
                  ),
                  SizedBox(height: 8),
                  Text("${first_name ?? ""} ${last_name ?? ""}",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("${email}", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('หน้าแรก'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Image.asset("assets/icons/BuyBack.png",scale: 20,),
              title: Text('ตะกร้า'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => Bucket()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('การแจ้งเตือน'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => Nontification()));
              },
            ),
          ],
        ),
      ),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Nontification()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/icons/Notification.png",
                    scale: 15,
                  ),
                ),
              ),
            ],
            leading: GestureDetector(
              onTap: () {
                     _scaffoldKey.currentState?.openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/icons/Vector.png", scale: 15),
              ),
            ),
            title: Text(
              "${first_name ?? ""} ${last_name ?? ""}",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
          ),
          body: Column(
            children: [
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
                  SizedBox(height: 10),
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
                      "แบร์นสินค้า",
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 241, 241, 241),
                    border: Border.all(color: kButtonColor)
                  ),
                  width: double.infinity,
                  height: size.height * 0.05,
                  child: TextFormField(
                    
                    controller: search,
                    style: TextStyle(fontSize: 22),
                    decoration: InputDecoration(
                      prefixIcon: Image.asset(
                        "assets/icons/Search.png",
                        scale: 20,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Search Band ...",
                      hintStyle: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IBMPlexSansThai',
                        color: kbgM,
                      ),
                    ),
                    onChanged: filterProducts,
                  ),
                ),
              ),
              filteredBand.isEmpty
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height*0.1,),
                  CircularProgressIndicator(
                    color: kButtonColor,
                  ),
                ],
              )
             : Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,

                    itemCount: filteredBand.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrandPage(
                                title: filteredBand[index].name ?? "",
                                brandId: filteredBand[index].id,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            // รูปสี่เหลี่ยมโค้งมน
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: 
                              filteredBand[index].image_url==null
                             ? Image.asset(
                                "assets/images/NoImage.jpg",
                                // ถ้าเป็นรูปจาก API ใช้ NetworkImage
                                // Image.network(brands[index].image ?? "url สำรอง"),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                             : Image.network(
                                "${filteredBand[index].image_url}",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Text(
                              filteredBand[index].name ?? "",
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              //  Padding(
              //    padding: const EdgeInsets.all(8.0),
              //    child: SingleChildScrollView(
              //      scrollDirection: Axis.horizontal,
              //      child: Row(
              //        children: List.generate(
              //          brands.length, // จำนวนแบรนด์ (แก้ตามจริง)
              //          (index) => Padding(
              //            padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //            child: GestureDetector(
              //             onTap: () {
              //               Navigator.push(context, MaterialPageRoute(builder: (context)=>BrandPage(title: brands[index].name ?? "", brandId:  brands[index].id,)));
              //             },
              //              child: Column(
              //                children: [

              //                  CircleAvatar(
              //                    radius: 30, // ขนาดวงกลม
              //                    backgroundImage: AssetImage("assets/images/NoImage.jpg"),
              //                    // หรือถ้าเป็น Network รูปจาก API ใช้:
              //                    // backgroundImage: NetworkImage("https://picsum.photos/200"),
              //                  ),
              //                  SizedBox(height: 6),
              //                  // ชื่อแบรนด์
              //                  Text(
              //                    "${brands[index].name}",
              //                    style: TextStyle(fontSize: 12),
              //                  ),
              //                ],
              //              ),
              //            ),
              //          ),
              //        ),
              //      ),
              //    ),
              //  ),

              // productTyp.isEmpty
              //     ? SizedBox.shrink()
              //     : Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Row(
              //           children: [
              //             ConstrainedBox(
              //               constraints: BoxConstraints(
              //                 maxWidth: size.width * 0.78,
              //               ), // กำหนดความกว้าง
              //               child: DropdownButtonFormField<ProductTyp>(
              //                 isExpanded: true,
              //                 dropdownColor: Colors.white,
              //                 decoration: InputDecoration(
              //                   labelText: "เลือกประเภทสินค้า",
              //                   labelStyle: TextStyle(color: kbgM),
              //                   filled: true,
              //                   fillColor: Colors.white,
              //                   contentPadding: EdgeInsets.symmetric(
              //                     horizontal: 12,
              //                     vertical: 8,
              //                   ),
              //                   border: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                     borderSide: BorderSide(color: kButtonColor),
              //                   ),
              //                   enabledBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                     borderSide: BorderSide(color: kButtonColor),
              //                   ),
              //                   focusedBorder: OutlineInputBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                     borderSide: BorderSide(
              //                       color: kButtonColor,
              //                       width: 2,
              //                     ),
              //                   ),
              //                 ),
              //                 items: productTyp.map((product) {
              //                   return DropdownMenuItem<ProductTyp>(
              //                     value: product,
              //                     child: Text(
              //                       product.name_en ?? "",
              //                       overflow: TextOverflow.ellipsis,
              //                       maxLines: 1,
              //                       style: TextStyle(fontSize: 14),
              //                     ),
              //                   );
              //                 }).toList(),
              //                 onChanged: (value) {
              //                   if (value != null) {
              //                     print("ID: ${value.id}");
              //                     print("Name: ${value.name_en}");
              //                     idPro = value.id.toString();
              //                     namePro = value.name_en ?? "";
              //                   }
              //                 },
              //               ),
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => Catagory(
              //                       id: idPro!,
              //                       title: namePro ?? "",
              //                     ),
              //                   ),
              //                 );
              //               },
              //               child: Container(
              //                 width: size.width * 0.15,
              //                 height: size.height * 0.05,
              //                 margin: const EdgeInsets.symmetric(horizontal: 4),
              //                 decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(8),

              //                   color: kButtonColor,
              //                 ),
              //                 child: Center(
              //                   child: Text(
              //                     "ค้นหา",
              //                     style: TextStyle(
              //                       fontSize: 12,
              //                       fontWeight: FontWeight.bold,
              //                       color: kbgf,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       SizedBox(width: size.width * 0.02),
              //       Text(
              //         "สินค้าแนะนำ",
              //         style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           color: kButtonColor,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // uniqueProducts.isEmpty
              //     ? Center(
              //         child: CircularProgressIndicator(
              //           color: kButtonColor,
              //         ), // แสดง loading
              //       )
              //     : Expanded(
              //         child: Padding(
              //           padding: const EdgeInsets.all(12.0),
              //           child: GridView.builder(
              //             itemCount: 4,
              //             gridDelegate:
              //                 SliverGridDelegateWithFixedCrossAxisCount(
              //                   crossAxisCount: 2,
              //                   crossAxisSpacing: 12,
              //                   mainAxisSpacing: 12,
              //                   childAspectRatio: 0.75,
              //                 ),
              //             itemBuilder: (context, index) {
              //               final selectedProduct =
              //                   uniqueProducts[index]; // <-- นี่คือ selectedProduct

              //               return Container(
              //                 decoration: BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.circular(16),
              //                   boxShadow: [
              //                     BoxShadow(
              //                       color: Colors.black12,
              //                       blurRadius: 6,
              //                       spreadRadius: 2,
              //                       offset: Offset(2, 4),
              //                     ),
              //                   ],
              //                 ),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.stretch,
              //                   children: [
              //                     // รูปสินค้า
              //                     Expanded(
              //                       child: ClipRRect(
              //                         borderRadius: const BorderRadius.vertical(
              //                           top: Radius.circular(16),
              //                         ),
              //                         child: selectedProduct?.image_url == null
              //                             ? Image.asset(
              //                                 "assets/images/NoImage.jpg",
              //                                 fit: BoxFit.cover,
              //                               )
              //                             : Image.network(
              //                                 selectedProduct!.image_url!,
              //                                 fit: BoxFit.cover,
              //                               ),
              //                       ),
              //                     ),

              //                     // ข้อมูล
              //                     Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             selectedProduct?.name_en ?? "",
              //                             maxLines: 1,
              //                             overflow: TextOverflow.ellipsis,
              //                             style: const TextStyle(
              //                               fontWeight: FontWeight.bold,
              //                             ),
              //                           ),
              //                           SizedBox(height: 4),
              //                           Row(
              //                             mainAxisAlignment:
              //                                 MainAxisAlignment.spaceBetween,
              //                             children: [
              //                               Text(
              //                                 formatNumber(
              //                                   selectedProduct?.srp_inc_vat ??
              //                                       "0",
              //                                 ),
              //                                 style: const TextStyle(
              //                                   fontSize: 14,
              //                                   fontWeight: FontWeight.w600,
              //                                 ),
              //                               ),

              //                               Consumer<FavoriteProvider>(
              //                                 builder: (context, favProvider, child) {
              //                                   final colors = product
              //                                       .where(
              //                                         (e) =>
              //                                             e.product!.id ==
              //                                             selectedProduct!.id,
              //                                       )
              //                                       .map((e) => e.color)
              //                                       .toList();

              //                                   final currentProduct = Shoping(
              //                                     productId: selectedProduct!.id
              //                                         .toString(),
              //                                     name:
              //                                         selectedProduct.name_en ??
              //                                         "",
              //                                     price: formatNumber(
              //                                       selectedProduct
              //                                               .srp_inc_vat ??
              //                                           "0",
              //                                     ),
              //                                     detail: "",
              //                                     colors: colors,
              //                                     color: '',
              //                                     nameTh:
              //                                         selectedProduct.name_th ??
              //                                         "",
              //                                     image:
              //                                         selectedProduct.image_url,
              //                                   );

              //                                   final isFav = favProvider
              //                                       .isFavorite(currentProduct);

              //                                   return GestureDetector(
              //                                     onTap: () {
              //                                       favProvider.toggleFavorite(
              //                                         currentProduct,
              //                                       );
              //                                     },
              //                                     child: Image.asset(
              //                                       isFav
              //                                           ? "assets/icons/HertOn.png"
              //                                           : "assets/icons/HertOff.png",
              //                                       scale: 15,
              //                                     ),
              //                                   );
              //                                 },
              //                               ),
              //                             ],
              //                           ),
              //                           SizedBox(height: 8),
              //                           SizedBox(
              //                             width: double.infinity,
              //                             child: ElevatedButton(
              //                               style: ElevatedButton.styleFrom(
              //                                 backgroundColor: kButtonColor,
              //                                 shape: RoundedRectangleBorder(
              //                                   borderRadius:
              //                                       BorderRadius.circular(8),
              //                                 ),
              //                               ),
              //                               onPressed: () {
              //                                 // หา colors ของ product ที่กด
              //                                 final colors = product
              //                                     .where(
              //                                       (e) =>
              //                                           e.product!.id ==
              //                                           selectedProduct!.id,
              //                                     )
              //                                     .map((e) => e.color)
              //                                     .toList();
              //                                 final sameproduct = product
              //                                     .where(
              //                                       (e) =>
              //                                           e.product!.id ==
              //                                           selectedProduct!.id,
              //                                     )
              //                                     .map((e) => e.product)
              //                                     .toList();
              //                                 Navigator.push(
              //                                   context,
              //                                   MaterialPageRoute(
              //                                     builder: (context) => Detailpro(
              //                                       sameproduct: sameproduct,
              //                                       image: selectedProduct
              //                                           ?.image_url,
              //                                       productId: selectedProduct!
              //                                           .id
              //                                           .toString(),
              //                                       proName:
              //                                           selectedProduct
              //                                               ?.name_en ??
              //                                           "",
              //                                       proPice: formatNumber(
              //                                         selectedProduct
              //                                                 ?.srp_inc_vat ??
              //                                             "",
              //                                       ),
              //                                       detail: '',
              //                                       color: colors,
              //                                       proNameTh:
              //                                           selectedProduct
              //                                               ?.name_th ??
              //                                           "",
              //                                     ),
              //                                   ),
              //                                 );
              //                               },
              //                               child: Text(
              //                                 "สั่งซื้อ",
              //                                 style: TextStyle(
              //                                   fontSize: 12,
              //                                   fontWeight: FontWeight.bold,
              //                                   color: kbgf,
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       ),
            ],
          ),
        );
      },
    );
  }
}
