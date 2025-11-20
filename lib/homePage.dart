import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/AllProduct.dart';
import 'package:t_and_c_mobile/category/brandPage.dart';
import 'package:t_and_c_mobile/claim.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/login.dart';
import 'package:t_and_c_mobile/model/NewProductModel/newdata.dart';
import 'package:t_and_c_mobile/model/brands.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/model/user.dart';
import 'package:t_and_c_mobile/nontification.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/compleated.dart';
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
  String? namebrand;

  int? test;

  Future<void> getapi() async {
    try {
      await context.read<ProductController>().getproducttypes();
      if (!mounted) return;
      await context.read<ProductController>().getproductcollection();
      if (!mounted) return;
      allbands = await ProductApi.listbrands();
      if (!mounted) return;
      custommer = await ProductApi.getUser();
      if (!mounted) return;
      setState(() {});
    } on Exception catch (e) {
      if (!mounted) return;
      LoadingDialog.close(context);
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: '$e' == "Unauthenticated"
              ? 'การเข้าสู่ระบบหมดอายุ'
              : '$e',
          pressYes: () {
            if (!mounted) return;
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
        final productcollection = controller.productcollection;
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
                    allbands.isEmpty
                        ? SizedBox.shrink()
                        : _buildSectionTitle("แบรนด์สินค้า"),
                    allbands.isEmpty
                        ? SizedBox.shrink()
                        : SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: allbands.length,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              itemBuilder: (context, index) {
                                final brand = allbands[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BrandPage(
                                          title: brand.name ?? "",
                                          brandId: brand.id,
                                          namebrand: '${brand.name}',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: brand.img_path == null
                                                // ? brand.name=="Anidary"
                                                ? Image.asset(
                                                    brand.name == "Anidary"
                                                        ? "assets/images/Anidary.WEBP"
                                                        : brand.name ==
                                                              "Allducube"
                                                        ? "assets/images/Alldocope.WEBP"
                                                        : brand.name == "Baseus"
                                                        ? "assets/images/Baseus.WEBP"
                                                        : "assets/images/NoImage.jpg",
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
                                  ),
                                );
                              },
                            ),
                          ),
                    Column(
                      children: List.generate(
                        productcollection.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                ContainerHeader(
                                  size: size,
                                  text: productcollection[index].name ?? "",
                                ),
                                productcollection[index].products!.isEmpty
                                    ? SizedBox(
                                        height: size.height * 0.3,
                                        child: Center(
                                          child: Text(
                                            "ไม่พบสินค้า",
                                            style: TextStyle(
                                              color: kbgM,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: GridView.builder(
                                          itemCount: productcollection[index]
                                              .products!
                                              .length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing: 12,
                                                mainAxisSpacing: 12,
                                                childAspectRatio: 0.75,
                                              ),
                                          itemBuilder: (context, index2) {
                                            final productcollections =
                                                productcollection[index]
                                                    .products![index2];
                                            return _buildProductCard(
                                              productcollections,
                                            );
                                          },
                                        ),
                                      ),
                              ],
                            ),
                          ),
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
                  MaterialPageRoute(
                    builder: (context) => FirstPage(profile: 3),
                  ),
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
          ListTile(
            leading: Icon(Icons.replay),
            title: Text('เคลมสินค้า'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ClaimPage()),
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
            MaterialPageRoute(
              builder: (_) => Allproduct(status: 'product', namebrand: ''),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favProvider, child) {
                      if (allbands.isNotEmpty) {
                        final brandMatch = allbands.firstWhere(
                          (b) => b.id == product.brand_id,
                        );
                        namebrand = brandMatch.name;
                      }
                      final currentProduct = Shoping(
                        warehouse_skus: firstSku?.warehouse_skus ?? [],
                        sku: firstSku?.sku ?? "",
                        image: firstSku?.image_url,
                        product_id: product.product_id.toString(),
                        name: product.name_en ?? "",
                        price: formatNumber(firstSku?.base_price ?? 0),
                        color: firstSku?.color?.name_en ?? "",
                        nameTh: product.name_th ?? "",
                        promotion: firstSku?.promotions ?? [],
                        newData: product,
                        namebrand: namebrand ?? "",
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
                              "฿ ${formatNumber(  promo.fixed_price ?? 0)}",
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
                      // print(test);
                      final brandMatch = allbands.firstWhere(
                        (b) => b.id == product.brand_id,
                      );

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
                            namebrand: brandMatch.name ?? "",
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
