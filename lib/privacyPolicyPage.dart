import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'login.dart'; // <-- import หน้าล็อกอินของคุณ

class PrivacyPolicyPage extends StatefulWidget {
  PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'นโยบายความเป็นส่วนตัว',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kButtonColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Text('''
🛡️ นโยบายความเป็นส่วนตัว (Privacy Policy)

มีผลบังคับใช้ ณ วันที่  20 ตุลาคม พ.ศ.2568

ยินดีต้อนรับสู่ TNC Partners (แอปพลิเคชัน) และเว็บไซต์ https://erp.tnc-thailand.com 
เรามุ่งมั่นในการปกป้องความเป็นส่วนตัวของคุณ และให้ความสำคัญกับความปลอดภัยของข้อมูลส่วนบุคคล โปรดอ่านนโยบายฉบับนี้อย่างรอบคอบ การเข้าถึงหรือการใช้งานบริการของเราถือว่าคุณยอมรับตามเงื่อนไขนี้

1. ข้อมูลที่เราเก็บรวบรวม
- ข้อมูลส่วนบุคคล เช่น ชื่อ อีเมล หมายเลขโทรศัพท์ รูปภาพ
- ข้อมูลที่ไม่ใช่ส่วนบุคคล เช่น IP เบราว์เซอร์ ระบบปฏิบัติการ

2. วัตถุประสงค์ในการใช้ข้อมูล
- เพื่อให้บริการและปรับปรุงบริการ
- เพื่อการติดต่อและสนับสนุนลูกค้า
- เพื่อส่งข้อมูลการตลาด
- เพื่อปฏิบัติตามกฎหมาย

3. การเปิดเผยข้อมูล
- ผู้ให้บริการที่เกี่ยวข้อง
- หน่วยงานของรัฐ (หากกฎหมายกำหนด)
- การโอนธุรกิจในอนาคต

4. คุกกี้และเทคโนโลยี
เราใช้คุกกี้เพื่อปรับปรุงประสบการณ์การใช้งาน คุณสามารถจัดการได้จากการตั้งค่าเบราว์เซอร์

5. สิทธิของเจ้าของข้อมูล
คุณสามารถขอเข้าถึง แก้ไข หรือลบข้อมูลของคุณได้โดยติดต่อเราที่ businesstncc@gmail.com

6. ความปลอดภัย
เรามีมาตรการป้องกันข้อมูลของคุณจากการเข้าถึงโดยไม่ได้รับอนุญาต

7. ความเป็นส่วนตัวของเด็ก
เราไม่เก็บข้อมูลจากผู้ที่มีอายุต่ำกว่า 13 ปี

8. การเปลี่ยนแปลงนโยบาย
เราอาจปรับปรุงนโยบายนี้เป็นระยะ และจะประกาศบนเว็บไซต์

9. ติดต่อเรา
TNC Partners  
อีเมล: businesstncc@gmail.com  
เว็บไซต์: https://erp.tnc-thailand.com
                    ''', style: const TextStyle(fontSize: 14, height: 1.5)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    activeColor: kButtonColor,
                    value: isAccepted,
                    onChanged: (value) {
                      setState(() {
                        isAccepted = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'ฉันได้อ่านและยอมรับนโยบายความเป็นส่วนตัว',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isAccepted
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Loginpage(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'ดำเนินการต่อ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
