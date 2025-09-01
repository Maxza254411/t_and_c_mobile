import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/order/detailPro.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class Catagory extends StatefulWidget {
  Catagory({super.key, required this.status});
  String status;
  @override
  State<Catagory> createState() => _CatagoryState();
}

class _CatagoryState extends State<Catagory> {
  final TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Buy.png", scale: 15),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Notification.png", scale: 15),
          ),
        ],
        title: Row(
          children: [
            widget.status == 'T'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/icons/TabGuoup.png', scale: 15),
                  )
                : widget.status == 'E'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/icons/eargroup.png', scale: 15),
                  )
                : widget.status == 'A'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/icons/AccGroup.png', scale: 15),
                  )
                : widget.status == 'P'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/PhoneGroup.png',
                      scale: 15,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/icons/AllGroup.png', scale: 15),
                  ),
            //
            SizedBox(width: 10),
            widget.status == 'T'
                ? Text(
                    "แท็บเล็ต",
                    style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
                  )
                : widget.status == 'E'
                ? Text(
                    "หูฟัง",
                    style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
                  )
                : widget.status == 'A'
                ? Text(
                    "ACC",
                    style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
                  )
                : widget.status == 'P'
                ? Text(
                    "โทรศัพท์",
                    style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
                  )
                : Text(
                    "อุปกรณ์ทั้งหมด",
                    style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
                  ),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: size.height * 0.08,
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: kbgf),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputTextFormField(
                  hintText: "Search here ...",
                  controller: search,
                  size: size,
                  heights: size.height * 0.05,
                  imagestatus: true,
                  images: "assets/icons/Search.png",
                  whatfield: false,
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.7,
            width: size.width * 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
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
                        // รูปสินค้า
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              product["image"]!,
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
                                product["title"]!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product["price"]!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // ปุ่มสั่งซื้อ
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
                                        builder: (context) => Detailpro(proName:  product["title"]!, proPice:  product["price"]!, detail:product["detail"]!,),
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
