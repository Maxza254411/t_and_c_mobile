import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/AllProduct.dart';
import 'package:t_and_c_mobile/category/brandPage.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/login.dart';
import 'package:t_and_c_mobile/model/brands.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/model/user.dart';
import 'package:t_and_c_mobile/nontification.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/detailPro.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/povider/favoriteProvider.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/loadingDialog.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController search = TextEditingController();
  int _currentIndex = 0;
  String? idPro;
  String? namePro;
  int? userId;
  List<Brands> allbands = [];
  List<Brands> filteredBand = [];
  User? custommer;
  final CarouselSliderController _controller = CarouselSliderController();
  List<Data> product = [];

  Future<void> getapi() async {
    try {
      // LoadingDialog.open(context);
      await context.read<ProductController>().getproducttypes();
      // final producs = await ProductApi.getproduct();
      final producs = await ProductApi.getproducttypesbyid(page: 1, id: 1);
      product = producs;
      allbands = await ProductApi.listbrands();
      custommer = await ProductApi.getUser();
      filteredBand = List.from(allbands);
      // if (mounted) {
        setState(() {});
    //  LoadingDialog.close(context); 
      // }
    } on Exception catch (e)  {
      LoadingDialog.close(context);
      await showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description:
         '$e' == "Unauthenticated"
           ?'การเข้าสู่ระบบหมดอายุ'
           :'$e',
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

  List<Data> get uniqueProducts {
    final Map<int, Data> map = {};
    for (var item in product) {
      if (!map.containsKey(item.product!.id)) {
        map[item.product!.id!] = item;
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

    return Consumer<ProductController>(
      builder: (context, controller, child) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: kbgH,
          drawer: _buildDrawer(context),
          appBar: _buildAppBar(context, cart),

          // ✅ Layout หลัก
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildCarousel(size),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(context),
                    filteredBand.isEmpty
                        ? SizedBox.shrink()
                        : _buildSectionTitle("แบรนด์สินค้า"),
                    filteredBand.isEmpty
                        ? SizedBox.shrink()
                        : SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredBand.length,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              itemBuilder: (context, index) {
                                final brand = filteredBand[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BrandPage(
                                          title: brand.name ?? "",
                                          brandId: brand.id, namebrand: '${brand.name}',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                     Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: brand.img_path == null
                                          ? Image.asset(
                                              "assets/images/Anidary.WEBP",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              brand.img_path!,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  
                                      SizedBox(height: 6),
                                      Text(
                                        brand.name ?? "",
                                        style: TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                    filteredBand.isEmpty
                        ? SizedBox.shrink()
                        : _buildSectionTitle("สินค้าแนะนำ"),
                    uniqueProducts.isEmpty
                        ? SizedBox.shrink()
                        : SizedBox(
                          height: size.height*0.7,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              itemCount: uniqueProducts.length < 4 ? 1 : 4,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.75,
                                  ),
                              itemBuilder: (context, index) {
                                final selectedProduct = uniqueProducts[index];
                          
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // รูปสินค้า
                                      // Expanded(
                                      //   child: ClipRRect(
                                      //     borderRadius:
                                      //         const BorderRadius.vertical(
                                      //           top: Radius.circular(16),
                                      //         ),
                                      //     child:
                                      //         selectedProduct
                                      //                 .product
                                      //                 ?.image_url ==
                                      //             null
                                      //         ? Image.asset(
                                      //             "assets/images/NoImage.jpg",
                                      //             fit: BoxFit.cover,
                                      //           )
                                      //         : Image.network(
                                      //             selectedProduct!
                                      //                     .product
                                      //                     ?.image_url ??
                                      //                 "",
                                      //             fit: BoxFit.cover,
                                      //           ),
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            // ----- รูปสินค้า -----
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(16),
                                                  ),
                                              child:
                                                  selectedProduct
                                                          .product
                                                          ?.image_url ==
                                                      null
                                                  ? Image.asset(
                                                      "assets/images/NoImage.jpg",
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    )
                                                  : Image.network(
                                                      selectedProduct
                                                          .product!
                                                          .image_url!,
                                                      fit: BoxFit.fitHeight,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      
                                                    ),
                                            ),
                          
                                            // ----- ถ้าของหมด แสดง Overlay -----
                                            if (selectedProduct
                                                    .warehouse_skus!
                                                    .isEmpty ||
                                                selectedProduct
                                                        .warehouse_skus![0]
                                                        .available ==
                                                    null)
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                      const BorderRadius.vertical(
                                                        top: Radius.circular(
                                                          16,
                                                        ),
                                                      ),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    "สินค้าหมด",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
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
                                              selectedProduct
                                                      .product
                                                      ?.name_en ??
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "฿ ${formatNumber(selectedProduct?.product?.srp_inc_vat ?? "0")}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                          
                                                Consumer<FavoriteProvider>(
                                                  builder: (context, favProvider, child) {
                                                    final colors = product
                                                        .where(
                                                          (e) =>
                                                              e.product!.id ==
                                                              selectedProduct!
                                                                  .id,
                                                        )
                                                        .map((e) => e.color)
                                                        .toList();
                          
                                                    final currentProduct = Shoping(
                                                      sku: selectedProduct
                                                          .sku!,
                                                      product_id:
                                                          selectedProduct!.id
                                                              .toString(),
                                                      name:
                                                          selectedProduct
                                                              .product
                                                              ?.name_en ??
                                                          "",
                                                      price: formatNumber(
                                                        selectedProduct
                                                                .product
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
                                                        .isFavorite(
                                                          currentProduct,
                                                        );
                          
                                                    return GestureDetector(
                                                      onTap: () {
                                                        favProvider
                                                            .toggleFavorite(
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
                                                  backgroundColor:
                                                      kButtonColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (selectedProduct
                                                          .warehouse_skus!
                                                          .isEmpty ||
                                                      selectedProduct
                                                              .warehouse_skus![0]
                                                              .available ==
                                                          null) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "ไม่พบสินค้าในคลัง",
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                          
                                                  final colors = product
                                                      .where(
                                                        (e) =>
                                                            e.product!.id ==
                                                            selectedProduct!
                                                                .id,
                                                      )
                                                      .map((e) => e.color)
                                                      .toList();
                                                  final sameproduct = product
                                                      .where(
                                                        (e) =>
                                                            e.product!.id ==
                                                            selectedProduct!
                                                                .id,
                                                      )
                                                      .map((e) => e.product)
                                                      .toList();
                          
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Detailpro(
                                                        sku: selectedProduct
                                                            .sku,
                                                        sameproduct:
                                                            sameproduct,
                                                        image:
                                                            selectedProduct!
                                                                .product
                                                                ?.image_url,
                                                        productId:
                                                            selectedProduct!
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
                                                    // หา colors ของ product ที่กด
                                                  );
                                                  }
                                                },
                                                child: Text(
                                                  "สั่งซื้อ",
                                                  style: TextStyle(
                                                    fontSize: 12,
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
                                );
                              },
                            ),
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
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
                  backgroundColor: Colors.white,
                  radius: 30,
                  backgroundImage: AssetImage("assets/icons/Vector.png"),
                ),
                SizedBox(height: 8),
                Text(
                  "${custommer?.first_name ?? ""} ${custommer?.last_name ?? ""}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${custommer?.email}",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          if (custommer?.customer != null)
            ListTile(
              leading: Icon(Icons.currency_exchange),
              title: Text(
                'เครดิต ${formatNumber(custommer?.customer?.current_credit_used ?? "0")}/${formatNumber(custommer?.customer?.credit_limit ?? "0")}',
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FirstPage(profile: 3)),
                );
                // LoadingDialog.close(context);
              },
            ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('หน้าแรก'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Image.asset("assets/icons/BuyBack.png", scale: 20),
            title: Text('ตะกร้า'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Bucket()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('การแจ้งเตือน'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Nontification()),
              );
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, CartProvider cart) {
    return AppBar(
      backgroundColor: kButtonColor,
      title: Text(
        "${custommer?.first_name ?? ""} ${custommer?.last_name ?? ""}",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset("assets/icons/Vector.png", scale: 15),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Bucket()),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset("assets/icons/Buy.png", scale: 15),
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
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Nontification()),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Notification.png", scale: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(Size size) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: imgList.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: EdgeInsets.all(6.0),
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
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _controller.animateToPage(entry.key);
                });
              },
              child: Container(
                width: 12,
                height: 12,
                margin: EdgeInsets.symmetric(horizontal: 4),
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
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Allproduct(status: 'product')),
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: kButtonColor,
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Data selectedProduct) {
    final colors = product
        .where((e) => e.product!.id == selectedProduct.product!.id)
        .map((e) => e.color)
        .toList();

    final sameproduct = product
        .where((e) => e.product!.id == selectedProduct.product!.id)
        .map((e) => e.product)
        .toList();

    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
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
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: selectedProduct.product?.image_url == null
                  ? Image.asset("assets/images/NoImage.jpg", fit: BoxFit.cover)
                  : Image.network(
                      selectedProduct.product!.image_url!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedProduct.product?.name_en ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatNumber(selectedProduct.product?.srp_inc_vat ?? "0"),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Consumer<FavoriteProvider>(
                      builder: (context, favProvider, child) {
                        final currentProduct = Shoping(
                          warehouse_skus: selectedProduct.warehouse_skus ?? [],
                          sku: selectedProduct.sku,
                          name: selectedProduct.product?.name_en ?? "",
                          price: formatNumber(
                            selectedProduct.product?.srp_inc_vat ?? "0",
                          ),
                          detail: "",
                          colors: colors,
                          color: '',
                          nameTh: selectedProduct.product?.name_th ?? "",
                          image: selectedProduct.product?.image_url,
                        );
                        final isFav = favProvider.isFavorite(currentProduct);
                        return GestureDetector(
                          onTap: () {
                            favProvider.toggleFavorite(currentProduct);
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Detailpro(
                            sku: selectedProduct.sku,
                            sameproduct: sameproduct,
                            image: selectedProduct.product?.image_url,
                            productId: selectedProduct.id.toString(),
                            proName: selectedProduct.product?.name_en ?? "",
                            proPice: formatNumber(
                              selectedProduct.product?.srp_inc_vat ?? "",
                            ),
                            detail: '',
                            color: colors,
                            proNameTh: selectedProduct.product?.name_th ?? "",
                            warehouse_skus:
                                selectedProduct.warehouse_skus ?? [],
                            //  selectedProduct: selectedProduct,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "สั่งซื้อ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
