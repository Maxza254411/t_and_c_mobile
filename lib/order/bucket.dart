import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/order/compleated.dart';

class Bucket extends StatefulWidget {
  const Bucket({super.key});

  @override
  State<Bucket> createState() => _BucketState();
}

class _BucketState extends State<Bucket> {
  @override
  void initState() {
    super.initState();
    checked = List.generate(products.length, (_) => false);
    quantities = List.generate(products.length, (_) => 1);
  }

  List<bool> checked = [];
  List<int> quantities = [];
  bool? check;
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
            child: Image.asset("assets/icons/Notification.png", scale: 15),
          ),
        ],
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset("assets/icons/BucketIcon.png", scale: 15),
            ),
            //
            SizedBox(width: 10),
            Text(
              "สินค้าในตะกร้า",
              style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Column(
            children: List.generate(
              products.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  height: size.height * 0.1,
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: kButtonColor,
                        value: checked[index],
                        onChanged: (value) {
                          setState(() {
                            checked[index] = value!;
                            check = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Image.asset(products[index]['image']!),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 1,
                          height: size.height * 0.05,
                          color: kButtonColor,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(children: [Text(products[index]["title"]!)]),
                          Row(
                            children: [
                              Text(products[index]["price"]!),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (quantities[index] > 1) {
                                            quantities[index]--;
                                          }
                                        });
                                      },
                                      child: Image.asset(
                                        "assets/icons/minus.png",
                                        scale: 30,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text("${quantities[index]}"),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          quantities[index]++;
                                        });
                                      },
                                      child: Image.asset(
                                        "assets/icons/Regular.png",
                                        scale: 30,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    
                                  });
                                },
                                child: Image.asset(
                                  "assets/icons/Trash.png",
                                  scale: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  height: size.height * 0.13,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("ราคารวม"), Text("0.00 บาท")],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (check == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Compleated(status: false,),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: check == true ? kButtonColor : kbgf,
                          ),
                          height: size.height * 0.05,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "ถัดไป",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: check == true ? kbgf : Colors.white,
                              ),
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
        ],
      ),
    );
  }
}
