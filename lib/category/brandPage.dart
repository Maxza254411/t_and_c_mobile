import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_and_c_mobile/allProduct.dart';
import 'package:t_and_c_mobile/category/catagory.dart';
import 'package:t_and_c_mobile/constang.dart';
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
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';

class BrandPage extends StatefulWidget {
  BrandPage({super.key, required this.title, required this.brandId});
  String title;
  int brandId;

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  int _currentIndex = 0;
  String? idPro;
  String? namePro;
  List<Data> product = [];
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
      await context.read<ProductController>().getproductypBybrandId(
        brandid: widget.brandId,
      );

      final producs = await ProductApi.getProBandId(
        brandid: widget.brandId,
        productTypid: 1,
        page: 1,
      );
      product = producs;
      setState(() {

      });

      // uniqueProducts = product.map((e) => e.product).toSet().toList();

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

  List<Data> get uniqueProducts {
    final Map<int, Data> map = {};
    for (var item in product) {
      if (!map.containsKey(item.product!.id)) {
        map[item.product!.id] = item;
      }
    }
    return map.values.toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getapi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
              child: Image.asset("assets/icons/Notification.png", scale: 15),
            ),
          ),
        ],

        title: Text(
          widget.title,
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<ProductController>(
        builder: (context, controller, child) {
          final productBandTyp = controller.productBandTyp;
          return Column(
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
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Allproduct(status: 'brand',brandId:  widget.brandId,)),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kButtonColor, width: 2),
          ),
          child: Row(
            children: [
              Image.asset("assets/icons/Search.png", scale: 20),
              SizedBox(width: 8),
              Text(
                "ค้นหาประเภทสินค้า ...",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'IBMPlexSansThai',
                  color: kbgM,
                ),
              ),
            ],
          ),
        ),
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
              uniqueProducts.isEmpty
                  ? Column(
                  children: [
                    SizedBox(height: size.height * 0.1),
                    Text(
                      "ไม่พบสินค้าแนะนำ",
                      style: TextStyle(
                        color: kbgM,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          itemCount: uniqueProducts.length < 4 ? 1 : 4,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            final selectedProduct =
                                uniqueProducts[index]; // <-- นี่คือ selectedProduct

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                    offset: Offset(2, 4),
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
                                      child:
                                          selectedProduct?.product?.image_url ==
                                              null
                                          ? Image.asset(
                                              "assets/images/NoImage.jpg",
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              selectedProduct!
                                                      .product
                                                      ?.image_url ??
                                                  "",
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),

                                  // ข้อมูล
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedProduct?.product?.name_en ??
                                              "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "฿ ${formatNumber(selectedProduct?.product?.srp_inc_vat ?? "0")}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            Consumer<FavoriteProvider>(
                                              builder: (context, favProvider, child) {
                                                final colors = product
                                                    .where(
                                                      (e) =>
                                                          e.product!.id ==
                                                          selectedProduct!.id,
                                                    )
                                                    .map((e) => e.color)
                                                    .toList();

                                                final currentProduct = Shoping(
                                                  sku: selectedProduct.sku!,
                                                  product_id: selectedProduct!
                                                      .id
                                                      .toString(),
                                                  name:
                                                      selectedProduct
                                                          .product
                                                          ?.name_en ??
                                                      "",
                                                  price: formatNumber(
                                                    selectedProduct
                                                            ?.product
                                                            ?.srp_inc_vat ??
                                                        "0",
                                                  ),
                                                  detail: "",
                                                  colors: colors,
                                                  color: '',
                                                  nameTh:
                                                      selectedProduct
                                                          .product
                                                          ?.name_th ??
                                                      "",
                                                  image: selectedProduct!
                                                      .product
                                                      ?.image_url,
                                                  warehouse_skus:
                                                      selectedProduct
                                                          .warehouse_skus ??
                                                      [],
                                                );

                                                final isFav = favProvider
                                                    .isFavorite(currentProduct);

                                                return GestureDetector(
                                                  onTap: () {
                                                    favProvider.toggleFavorite(
                                                      currentProduct,
                                                    );
                                                  },
                                                  child: Image.asset(
                                                    isFav
                                                        ? "assets/icons/HertOn.png"
                                                        : "assets/icons/HertOff.png",
                                                    scale: 15,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: kButtonColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              // หา colors ของ product ที่กด
                                              final colors = product
                                                  .where(
                                                    (e) =>
                                                        e.product!.id ==
                                                        selectedProduct!.id,
                                                  )
                                                  .map((e) => e.color)
                                                  .toList();
                                              final sameproduct = product
                                                  .where(
                                                    (e) =>
                                                        e.product!.id ==
                                                        selectedProduct!.id,
                                                  )
                                                  .map((e) => e.product)
                                                  .toList();

                                                  
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Detailpro(
                                                    sku: selectedProduct.sku,
                                                    sameproduct: sameproduct,
                                                    image: selectedProduct!
                                                        .product
                                                        ?.image_url,
                                                    productId: selectedProduct!
                                                        .id
                                                        .toString(),
                                                    proName:
                                                        selectedProduct
                                                            .product
                                                            ?.name_en ??
                                                        "",
                                                    proPice: formatNumber(
                                                      selectedProduct
                                                              .product
                                                              ?.srp_inc_vat ??
                                                          "",
                                                    ),
                                                    detail: '',
                                                    color: colors,
                                                    proNameTh:
                                                        selectedProduct
                                                            .product
                                                            ?.name_th ??
                                                        "",
                                                    warehouse_skus:
                                                        selectedProduct
                                                            .warehouse_skus ??
                                                        [],
                                                  //  selectedProduct: product[index],
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
          );
        },
      ),
    );
  }
}
