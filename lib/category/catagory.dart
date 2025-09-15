import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/data.dart';
import 'package:t_and_c_mobile/order/detailPro.dart';
import 'package:t_and_c_mobile/service/productApi.dart';
import 'package:t_and_c_mobile/service/productController.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class Catagory extends StatefulWidget {
  Catagory({super.key, required this.id, required this.title});

  String id;
  String title;

  @override
  State<Catagory> createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> {
  final TextEditingController search = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  List<Data> products = [];

  Future<void> getapi({bool isLoadMore = false}) async {
    try {
      if (_isLoadingMore || !_hasMore) return;

      if (isLoadMore) {
        setState(() => _isLoadingMore = true);
      }

      final newProducts = await ProductApi.getproductbyid(
        id: int.parse(widget.id),
        page: _page,
      );

      if (newProducts.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      } else {
        setState(() {
          if (isLoadMore) {
            products.addAll(newProducts); // ✅ ต่อท้าย
          } else {
            products = newProducts; // ✅ หน้าแรกทับได้
          }
          _page++;
        });
      }
    } on Exception catch (e) {
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
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getapi();
    });

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<ProductController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: kbgH,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: kButtonColor,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
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
              // Search
              Container(
                height: size.height * 0.08,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: kbgf),
                child: InputTextFormField(
                  hintText: "Search here ...",
                  controller: search,
                  size: size,
                  heights: size.height * 0.05,
                  imagestatus: true,
                  images: "assets/icons/Search.png",
                  whatfield: false,
                  width: double.infinity,
                ),
              ),

              // GridView
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    controller: _scrollController,
                    itemCount: products.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      if (index < products.length) {
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
                              // รูป
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: product.product?.image_url == null
                                      ? Image.asset(
                                          "assets/images/NoImage.jpg",
                                          fit: BoxFit.cover,
                                        )
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
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatNumber(
                                        product.product?.srp_inc_vat ?? "0",
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
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
                                                proName:
                                                    product.product?.name_en ??
                                                    "",
                                                proPice: formatNumber(
                                                  product .product?.srp_inc_vat ?? "0",
                                                ),

                                                detail: "",
                                                color:
                                                    product.color?.name_en ??
                                                    " - ",
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
                      } else {
                        // Loader ด้านล่าง
                        return _isLoadingMore
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: kButtonColor,
                                ),
                              )
                            : const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
