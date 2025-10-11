import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/model/shoping.dart';
import 'package:t_and_c_mobile/model/warehouse.dart';
import 'package:t_and_c_mobile/order/detailPro.dart';
import 'package:t_and_c_mobile/povider/favoriteProvider.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';

class Catagory extends StatefulWidget {
  Catagory({
    super.key,
    required this.brandid,
    required this.title,
    required this.productTypid,
    required this.statusPage,
  });
  final int brandid;
  final String title;
  final int productTypid;
  final String statusPage;

  @override
  State<Catagory> createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> {
  final TextEditingController search = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  List<Data> allProducts = []; // เก็บข้อมูลทั้งหมด
  List<Data> filteredProducts = []; // เก็บข้อมูลกรองแล้ว
  List<Warehouse> listwarehouse = [];

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
  void dispose() {
    _scrollController.dispose();
    search.dispose();
    super.dispose();
  }

  Future<void> getapi({bool isLoadMore = false}) async {
    try {
      if (_isLoadingMore || !_hasMore) return;

      if (isLoadMore) setState(() => _isLoadingMore = true);
      if (widget.statusPage == "brand") {
        final newProducts = await ProductApi.getProBandId(
          brandid: widget.brandid,
          productTypid: widget.productTypid,
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
      } else {
        /////////
        final newProducts = await ProductApi.getproducttypesbyid(
          page: _page,
          id: widget.productTypid,
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
      filteredProducts = allProducts
          .where(
            (item) =>
                item.product?.name_en?.toLowerCase().contains(
                  keyword.toLowerCase(),
                ) ??
                false,
          )
          .toList();
    }
    setState(() {});
  }

  /// สร้าง list ไม่ซ้ำตาม product.id
  List<Data> get uniqueProducts {
    final Map<int, Data> map = {};
    for (var item in filteredProducts) {
      if (!map.containsKey(item.product!.id)) {
        map[item.product!.id] = item;
      }
    }
    return map.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              
              controller: search,
              style: TextStyle(fontSize: 22),
              decoration: InputDecoration(
                   filled: true,
                fillColor: Colors.white,
                prefixIcon: Image.asset("assets/icons/Search.png", scale: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kButtonColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kButtonColor, width: 2),
                ),
                hintText: "Search Product ...",
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: 'IBMPlexSansThai',
                  color: kbgM,
                ),
              ),
              onChanged: filterProducts,
            ),
          ),

          // GridView
          uniqueProducts.isEmpty
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
                          uniqueProducts.length + (_isLoadingMore ? 1 : 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        if (index < uniqueProducts.length) {
                          final product = uniqueProducts[index];
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
      ),
    );
  }

  Widget _buildProductCard(Data product) {
    // สร้าง list สีทั้งหมดของสินค้านี้
    final productColors = allProducts
        .where((item) => item.product!.id == product.product!.id)
        .map((e) => e.color)
        .toList();
    final sameproduct = allProducts
        .where((item) => item.product!.id == product.product!.id)
        .map((e) => e.product)
        .toList();

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
              child: product.product?.image_url == null
                  ? Image.asset("assets/images/NoImage.jpg", fit: BoxFit.cover)
                  : Image.network(
                      product.product!.image_url!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),

          // ข้อมูล
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.product?.name_en ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "฿ ${formatNumber(product.product?.srp_inc_vat ?? "0")}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Consumer<FavoriteProvider>(
                      builder: (context, favProvider, child) {
                        final currentProduct = Shoping(
                          warehouse_skus: product.warehouse_skus ?? [],
                          sku: product.sku,
                          image: product.product?.image_url,
                          product_id: product.product?.id.toString(),
                          name: product.product?.name_en ?? "",
                          price: formatNumber(
                            product.product?.srp_inc_vat ?? "0",
                          ),
                          detail: "",
                          colors: productColors,
                          color: '',
                          nameTh: product.product?.name_th ?? "",
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
                          builder: (context) => Detailpro(
                            sameproduct: sameproduct,
                            image: product.product?.image_url,
                            productId: product.product?.id.toString() ?? "",
                            proName: product.product?.name_en ?? "",
                            proPice: formatNumber(
                              product.product?.srp_inc_vat ?? "0",
                            ),
                            detail: '',
                            color: productColors,
                            proNameTh:
                                product.product?.name_th, // ส่ง list สีทั้งหมด
                            sku: product.sku,
                            warehouse_skus: product.warehouse_skus ?? [],
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
