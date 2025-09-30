import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/nontification.dart';
import 'package:t_and_c_mobile/payment/promptPayTab.dart';

class Paybank extends StatefulWidget {
  const Paybank({super.key});

  @override
  State<Paybank> createState() => _PaybankState();
}

class _PaybankState extends State<Paybank> {
  
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        backgroundColor: kButtonColor,
        centerTitle: true,
         iconTheme: IconThemeData(
              color: Colors.white
            ),
 
        title: Text(
          "ชำระเงิน",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height:
                    size.height * 0.5, // เพิ่มความสูงหน่อยเพื่อให้มีที่วาง Tab
                width: size.width * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DefaultTabController(
                  length: 2, // จำนวนแท็บ
                  child: Column(
                    children: [
                      // --- แถบ TabBar ---
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: kButtonColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          indicatorPadding: EdgeInsets.symmetric(
                            vertical: 10,
                          ), // << ปรับขนาด
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tab(text: "เลขบัญชี"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Tab(text: "พร้อมเพย์"),
                            ),
                          ],
                        ),
                      ),

                      // --- เนื้อหาในแต่ละแท็บ ---
                      Expanded(
                        child: TabBarView(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // 🏦 ชื่อธนาคาร
                                  Text(
                                    "ธนาคารกสิกรไทย",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // 🔢 เลขบัญชี
                                  Text(
                                    "123-456-789-0",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      letterSpacing: 2,
                                    ),
                                  ),

                                   SizedBox(height: 20),

                                  // 📋 ปุ่มคัดลอก
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(text: "1234567890"),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text("คัดลอกเลขบัญชีแล้ว"),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.copy),
                                    label: Text("คัดลอกเลขบัญชี"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kButtonColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Center(child: PromptPayTab()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ],
      ),
    );
  }
}
