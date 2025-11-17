
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/NewProductModel/newdata.dart';
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
    required this.namebrand,
  });
  final int brandid;
  final String title;
  final int productTypid;
  final String statusPage;
  final String namebrand;

  @override
  State<Catagory> createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> {
  final TextEditingController search = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  List<Newdata> allProducts = []; 
  List<Newdata> filteredProducts = []; 
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
    final lowerKeyword = keyword.toLowerCase();
    filteredProducts = allProducts.where((item) {
      final nameEn = item.name_en?.toLowerCase() ?? '';
      final nameTh = item.name_th?.toLowerCase() ?? '';

      // ดึง SKU ทั้งหมดจาก skus list
      final skus = (item.skus ?? [])
          .map((skuItem) => skuItem.sku?.toLowerCase() ?? '')
          .toList();

      // ให้ค้นได้ทั้งชื่อสินค้าไทย อังกฤษ และรหัส SKU
      final matchName = nameEn.contains(lowerKeyword) || nameTh.contains(lowerKeyword);
      final matchSku = skus.any((sku) => sku.contains(lowerKeyword));

      return matchName || matchSku;
    }).toList();
  }

  setState(() {});
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
                          filteredProducts.length + (_isLoadingMore ? 1 : 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      ),
    );
  }

Widget _buildProductCard(Newdata product) {
  // ดึง SKU ตัวแรกมาแสดง (กรณีมีหลายสี)
  final firstSku = product.skus!.isNotEmpty ? product.skus![0] : null;
  final isOutOfStock = firstSku == null ||
      firstSku.warehouse_skus!.isEmpty ||
      (firstSku.warehouse_skus![0].available ?? 0) <= 0;

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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
              if (isOutOfStock)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Center(
                    child: Text(
                      "สินค้าหมด",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                          name: product.name_en ?? "",
                          price: formatNumber(firstSku?.base_price ?? 0),
                          color: firstSku?.color?.name_en ?? "",
                          nameTh: product.name_th ?? "",
                       
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
          padding:  EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name_en ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(fontWeight: FontWeight.bold),
              ),
               SizedBox(height: 4),

              // -------- ราคา --------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (firstSku != null)
                   firstSku.promotions!.isNotEmpty
                        ? Row(
                            children: [
                              Text(
                                "฿ ${formatNumber(firstSku.promotions![0].fixed_price ?? 0)}",
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
                          )
                        : Text(
                            "฿ ${formatNumber(firstSku.base_price ?? 0)}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
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
                  onPressed:
                       () {
                    //  print( firstSku?.promotions![0].promotion_id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detailpro(
                                image: firstSku?.image_url,
                                productId: product.product_id.toString(),
                                proName: product.name_en ?? "",
                                proPice: firstSku!.promotions!.isNotEmpty
                                    ? formatNumber(firstSku.promotions![0].fixed_price ?? 0)
                                    : formatNumber(firstSku.base_price ?? 0),
                                proNameTh: product.name_th,
                                warehouse_skus: firstSku.warehouse_skus!,
                                namebrand: widget.namebrand,
                                promotion: firstSku.promotions!, skulist: [], skuid: [], newdata: product,
                                
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
