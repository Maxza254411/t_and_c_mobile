import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/allProduct.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/NewProductModel/newdata.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';
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
  BrandPage({
    super.key,
    required this.title,
    required this.brandId,
    required this.namebrand,
  });
  String title;
  int brandId;
  String namebrand;

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  int _currentIndex = 0;
  String? idPro;
  String? namePro;
  List<Newdata> product = [];
  final CarouselSliderController _controller = CarouselSliderController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController search = TextEditingController();

  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  List<Newdata> allProducts = [];
  List<Newdata> filteredProducts = [];
  List<Warehouse> listwarehouse = [];

  void _goToPage(int index) {
    // ✅ เช็คก่อนว่า controller attach แล้วหรือยัง
    if (_controller.ready) {
      _controller.animateToPage(index);
    } else {
      debugPrint("CarouselSlider ยังไม่พร้อม");
    }
  }

  Future<void> getapi({bool isLoadMore = false}) async {
    try {
      if (_isLoadingMore || !_hasMore) return;
      if (isLoadMore) setState(() => _isLoadingMore = true);

      final newProducts = await ProductApi.getProBandId(
        brandid: widget.brandId,
        productTypid: 0,
        page: _page,
      );

      if (newProducts.isEmpty) {
        setState(() => _hasMore = false);
      } else {
        setState(() {
          if (isLoadMore) {
            allProducts.addAll(newProducts);
          } else {
            allProducts = newProducts;
          }
          _page++;
          filterProducts(search.text);
        });
      }
    } catch (e) {
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '$e',
          pressYes: () => Navigator.pop(context),
        ),
      );
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      filteredProducts = List.from(allProducts);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      filteredProducts = allProducts.where((item) {
        final nameEn = item.name_en?.toLowerCase() ?? '';
        final nameTh = item.name_th?.toLowerCase() ?? '';

        // ดึง SKU ทั้งหมดจาก skus list
        final skus = (item.skus ?? [])
            .map((skuItem) => skuItem.sku?.toLowerCase() ?? '')
            .toList();

        // ให้ค้นได้ทั้งชื่อสินค้าไทย อังกฤษ และรหัส SKU
        final matchName =
            nameEn.contains(lowerKeyword) || nameTh.contains(lowerKeyword);
        final matchSku = skus.any((sku) => sku.contains(lowerKeyword));

        return matchName || matchSku;
      }).toList();
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getapi());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        getapi(isLoadMore: true);
      }
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
                      MaterialPageRoute(
                        builder: (context) => Allproduct(
                          status: 'brand',
                          brandId: widget.brandId,
                          namebrand: widget.namebrand,
                        ),
                      ),
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
              filteredProducts.isEmpty
                  ? Column(
                      children: [
                        SizedBox(height: size.height * 0.3),
                        Text(
                          "ไม่พบสินค้า",
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
                          controller: _scrollController,
                          itemCount:
                              filteredProducts.length +
                              (_isLoadingMore ? 1 : 0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                              ),
                          itemBuilder: (context, index) {
                            if (index < filteredProducts.length) {
                              final product = filteredProducts[index];
                              return _buildProductCard(product);
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: kButtonColor,
                                ),
                              );
                            }
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

  Widget _buildProductCard(Newdata product) {
    // ดึง SKU ตัวแรกมาแสดง (กรณีมีหลายสี)
    final firstSku = product.skus!.isNotEmpty ? product.skus![0] : null;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
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
          // ---------------- รูปสินค้า ----------------
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: firstSku?.image_url == null
                      ? Image.asset(
                          "assets/images/NoImage.jpg",

                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.network(
                          firstSku!.image_url!,
                          fit: BoxFit.fitHeight,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                ),

                // -------- แสดงข้อความ "สินค้าหมด" --------
                // if (isOutOfStock)
                //   Container(
                //     decoration: BoxDecoration(
                //       color: Colors.black.withOpacity(0.6),
                //       borderRadius: const BorderRadius.vertical(
                //         top: Radius.circular(16),
                //       ),
                //     ),
                //     child: const Center(
                //       child: Text(
                //         "สินค้าหมด",
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favProvider, child) {
                  
                      final currentProduct = Shoping(
                        warehouse_skus: firstSku?.warehouse_skus ?? [],
                        sku: firstSku?.sku ?? "",
                        image: firstSku?.image_url,
                        product_id: product.product_id.toString(),
                        name: product.name_en ?? "",
                        price: formatNumber(firstSku?.base_price ?? 0),
                        color: firstSku?.color?.name_en ?? "",
                        nameTh: product.name_th ?? "",
                        newData: product,
                        namebrand: widget.namebrand
                      );

                      final isFav = favProvider.isFavorite(currentProduct);

                      return GestureDetector(
                        onTap: () => favProvider.toggleFavorite(currentProduct),
                        child: Image.asset(
                          isFav
                              ? "assets/icons/HertOn.png"
                              : "assets/icons/HertOff.png",
                          scale: 15,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ---------------- ข้อมูลสินค้า ----------------
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name_en ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),

                // -------- ราคา --------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (firstSku != null)
                      () {
                        final promos = firstSku.promotions;

                        // 1. กรณีไม่มีโปรโมชัน
                        if (promos == null || promos.isEmpty) {
                          return Text(
                            "฿ ${formatNumber(firstSku.base_price ?? 0)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }

                        // มีโปร ตรวจ promotion_id
                        final promo = promos.first;

                        // 2. ถ้า promotion_id == 2 → แสดงราคาเต็ม
                        if (promo.promotion_id == 2) {
                          return Text(
                            "฿ ${formatNumber(firstSku.base_price ?? 0)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }

                        // 3. มีโปร และ promotion_id != 2 → แสดงราคาโปร + ขีดฆ่าราคาเต็ม
                        return Row(
                          children: [
                            Text(
                              "฿ ${formatNumber(promo.fixed_price ?? 0)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "฿ ${formatNumber(firstSku.base_price ?? 0)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        );
                      }()
                    else
                      const Text("ไม่มีข้อมูลราคา"),
                  ],
                ),

                const SizedBox(height: 8),

                // -------- ปุ่มสั่งซื้อ --------
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      //  print( firstSku?.promotions![0].promotion_id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detailpro(
                            image: firstSku?.image_url,
                            productId: product.product_id.toString(),
                            proName: product.name_en ?? "",
                            proPice: firstSku!.promotions!.isNotEmpty
                                ? formatNumber(
                                    firstSku.promotions![0].fixed_price ?? 0,
                                  )
                                : formatNumber(firstSku.base_price ?? 0),
                            proNameTh: product.name_th,
                            warehouse_skus: firstSku.warehouse_skus!,
                            namebrand: widget.namebrand,
                            promotion: firstSku.promotions!,
                            newdata: product,
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
  }
}
