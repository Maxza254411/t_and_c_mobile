import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/NewProductModel/newdata.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/nontification.dart';
import 'package:t_and_c_mobile/order/bucket.dart';
import 'package:t_and_c_mobile/order/detailPro.dart';
import 'package:t_and_c_mobile/povider/cartProvider.dart';
import 'package:t_and_c_mobile/povider/favoriteProvider.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final TextEditingController search = TextEditingController();
  List<Shoping> filteredFavorites = [];

  void filterProducts(String query) {
    final favProvider = Provider.of<FavoriteProvider>(context, listen: false);

    if (query.isEmpty) {
      setState(() {
        filteredFavorites = favProvider.favorites;
      });
    } else {
      setState(() {
        filteredFavorites = favProvider.favorites.where((item) {
          final nameLower = item.name.toLowerCase();
          final skuLower = item.sku!.toLowerCase();
          final searchLower = query.toLowerCase();
          return nameLower.contains(searchLower) || skuLower.contains(searchLower);
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final favProvider = Provider.of<FavoriteProvider>(context, listen: false);
    filteredFavorites = favProvider.favorites; // เริ่มต้นเอาทั้งหมด
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cart = Provider.of<CartProvider>(context);
    final favProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        backgroundColor: kButtonColor,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Bucket()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Nontification()));
            },
            child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset("assets/icons/Notification.png", scale: 15)),
          ),
        ],
        title: Text(
          "Wishlist",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: favProvider.favorites.isEmpty
          ? Center(
              child: Text(
                "ยังไม่มีสินค้าที่ชอบ",
                style: TextStyle(color: kbgM, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 241, 241, 241),
                        border: Border.all(color: kButtonColor),
                      ),
                      width: double.infinity,
                      height: size.height * 0.05,
                      child: TextFormField(
                        controller: search,
                        style: TextStyle(fontSize: 22),
                        decoration: InputDecoration(
                          prefixIcon: Image.asset("assets/icons/Search.png", scale: 20),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Search here ...",
                          hintStyle: TextStyle(fontSize: 20, fontFamily: 'IBMPlexSansThai', color: kbgM),
                        ),
                        onChanged: filterProducts,
                      ),
                    ),
                  ),

                  // GridView
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: filteredFavorites.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75),
                      itemBuilder: (context, index) {
                        final item = filteredFavorites[index];
                        return _buildProductCard(item, item.namebrand ?? "");
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProductCard(Shoping product, String nameband) {
    // ดึง SKU ตัวแรกมาแสดง (กรณีมีหลายสี)
    final firstSku = product.newData!.skus!.isNotEmpty ? product.newData!.skus![0] : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2, offset: Offset(2, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---------------- รูปสินค้า ----------------
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: firstSku?.image_url == null
                      ? Image.asset("assets/images/NoImage.jpg", width: double.infinity, height: double.infinity, fit: BoxFit.fitHeight)
                      : Image.network(firstSku!.image_url!, fit: BoxFit.fitHeight, width: double.infinity, height: double.infinity),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favProvider, child) {
                      final currentProduct = Shoping(
                        warehouse_skus: firstSku?.warehouse_skus ?? [],
                        sku: firstSku?.sku ?? "",
                        image: firstSku?.image_url,
                        product_id: product.product_id.toString(),
                        name: product.newData!.name_en ?? "",
                        price: formatNumber(firstSku?.base_price ?? 0),
                        color: firstSku?.color?.name_en ?? "",
                        nameTh: product.newData!.name_th ?? "",
                        promotion: firstSku?.promotions ?? [],
                        newData: product.newData!,
                        namebrand: nameband,
                      );

                      final isFav = favProvider.isFavorite(currentProduct);

                      return GestureDetector(
                        onTap: () => favProvider.toggleFavorite(currentProduct),
                        child: Image.asset(isFav ? "assets/icons/HertOn.png" : "assets/icons/HertOff.png", scale: 15),
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
                  product.newData!.name_en ?? "",
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
                          return Text("฿ ${formatNumber(firstSku.base_price ?? 0)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
                        }

                        // มีโปร ตรวจ promotion_id
                        final promo = promos.first;

                        // 2. ถ้า promotion_id == 2 → แสดงราคาเต็ม
                        if (promo.promotion_id == 2 || promo.promotion_id == 4) {
                          return Text("฿ ${formatNumber(firstSku.base_price ?? 0)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
                        }

                        // 3. มีโปร และ promotion_id != 2 → แสดงราคาโปร + ขีดฆ่าราคาเต็ม
                        return Row(
                          children: [
                            Text(
                              "฿ ${formatNumber(promo.fixed_price ?? 0)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "฿ ${formatNumber(firstSku.base_price ?? 0)}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detailpro(
                            image: firstSku?.image_url,
                            productId: product.product_id.toString(),
                            proName: product.newData!.name_en ?? "",
                            proPice: firstSku!.promotions!.isNotEmpty ? formatNumber(firstSku.promotions![0].fixed_price ?? 0) : formatNumber(firstSku.base_price ?? 0),
                            proNameTh: product.newData!.name_th,
                            warehouse_skus: firstSku.warehouse_skus!,
                            namebrand: nameband,
                            promotion: firstSku.promotions!,

                            newdata: product.newData!,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "สั่งซื้อ",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kbgf),
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
