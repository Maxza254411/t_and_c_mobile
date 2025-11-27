import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';

class ClaimPage extends StatefulWidget {
  const ClaimPage({super.key});

  @override
  State<ClaimPage> createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        backgroundColor: kButtonColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "เคลมสินค้า",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: kButtonColor, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("เงื่อนไขการรับประกัน หลังจากได้รับสินค้าบริษัทฯ จะดำเนินการไม่เกิน 14 วัน", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    '''    บริษัท ทีแอนด์ซี จำกัด อาคารชำนาญเพ็ญชาติ บิสเนสเซ็นเตอร์ ห้องเลขที่ 65/184 ชั้น 22 ถนน พระราม9 แขวง ห้วยขวาง เขต ห้วยขวาง กรุงเทพฯ 10310 ''',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text("เบอร์โทร  xxx-xxxxxxx", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
