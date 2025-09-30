import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
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
          final searchLower = query.toLowerCase();
          return nameLower.contains(searchLower);
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
          "Wishlist",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: favProvider.favorites.isEmpty
          ? Center(
              child: Text(
                "ยังไม่มีสินค้าที่ชอบ",
                style: TextStyle(
                  color: kbgM,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              children: [
                // Search Bar
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
                        hintText: "Search here ...",
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
                // GridView
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: filteredFavorites.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredFavorites[index];
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
                                  child: item.image == null
                                      ? Image.asset(
                                          "assets/images/NoImage.jpg",
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          item.image!,
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
                                      item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "฿ ${item.price}" ,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Consumer<FavoriteProvider>(
                                          builder: (context, favProvider, child) {
                                            final currentProduct = Shoping(
                                              sku: item.sku,
                                              product_id: item.product_id,
                                              name: item.name,
                                              price: item.price,
                                              detail: "",
                                              colors: item.colors,
                                              color: '',
                                              nameTh: item.nameTh,
                                            );
                                            final isFav = favProvider
                                                .isFavorite(currentProduct);
                                            return GestureDetector(
                                              onTap: () {
                                                favProvider.toggleFavorite(
                                                  currentProduct,
                                                );
                                                filterProducts(search.text);
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
                                                   sku:item.sku,
                                                sameproduct:item. sameproduct,
                                                image: item.image,
                                                productId: item.product_id!,
                                                proName: item.name,
                                                proPice: item.price,
                                                detail: '',
                                                color: item.colors,
                                                proNameTh: item.nameTh,
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
    );
  }
}
