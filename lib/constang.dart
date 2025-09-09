import 'package:flutter/material.dart';

const kButtonColor = Color(0xFF2C64AF);
const kbgf = Color(0xFFE4E4E4);
const kbgM = Color(0xFFE939393);
const ktextColr = Color(0xFFED2324);
const kbgH = Color(0xFFEE7E7E7);
const kbgc = Color(0xFFE9FFF8);

const String publicUrl = 'dev-erp.tnc-thailand.com';

final List<String> imgList = [
  "assets/images/banner 1.png",
  "assets/images/banner 2.png",
  "assets/images/banner 3.png",
];
final List<Map<String, String>> productMog = [
  {
    "image": "assets/images/NoImage.jpg",
    "title": "Airpods pro",
    "price": "0.00 บาท",
    "detail":
        '''AirPods Pro เป็นหูฟังไร้สายรุ่นพรีเมียมจาก Apple ที่มาพร้อมระบบ Active Noise Cancellation (ตัดเสียงรบกวนรอบข้าง) และ Transparency Mode (โหมดฟังเสียงภายนอก) ช่วยให้ปรับการใช้งานตามสภาพแวดล้อมได้สะดวก ด้านดีไซน์เป็นแบบ In-ear พร้อมจุกซิลิโคน 3 ขนาด เพื่อความกระชับและกันเสียงได้ดี มีชิป H1 ที่ช่วยเชื่อมต่อรวดเร็ว ลดความหน่วงเวลา พร้อมรองรับ Siri แบบ Hands-Free แบตเตอรี่ใช้งานได้ประมาณ 4.5–5 ชั่วโมงต่อการชาร์จหนึ่งครั้ง และเมื่อใช้ร่วมกับ เคสชาร์จ MagSafe จะเพิ่มเวลาใช้งานรวมได้กว่า 24 ชั่วโมง อีกทั้งยังมีคุณสมบัติ ทนน้ำและเหงื่อ (IPX4) เหมาะสำหรับการใช้งานประจำวันและการออกกำลังกาย.''',
  },
  {
    "image": "assets/images/NoImage.jpg",
    "title": "Aestheic Mug - white",
    "price": "0.00 บาท",
    "detail":
        '''Aesthetic Mug คือแก้วมัคที่ออกแบบมาให้มีความสวยงามและบ่งบอกสไตล์ของผู้ใช้ ทั้งในด้านสีสัน วัสดุ และลวดลาย ไม่ว่าจะเป็นโทนมินิมอลอย่างสีขาว ครีม เบจ หรือโทนพาสเทลที่ให้ความรู้สึกอบอุ่นละมุนตา บางแบบอาจเป็นเซรามิกเงา ดินเผาเคลือบด้าน หรือแก้วใสที่ดูเรียบหรู ใช้คู่กับการจัดโต๊ะกาแฟหรือโต๊ะทำงานเพื่อเพิ่มบรรยากาศที่ผ่อนคลายและดูมีรสนิยม ทำให้ไม่ใช่เพียงภาชนะสำหรับดื่มกาแฟหรือชาเท่านั้น แต่ยังเป็นของตกแต่งที่ช่วยสร้างบรรยากาศและ mood ให้กับทุกช่วงเวลา. ''',
  },
  {
    "image": "assets/images/NoImage.jpg",
    "title": "Gaming Monitor",
    "price": "0.00 บาท",
    "detail":
        '''Gaming Monitor คือจอมอนิเตอร์ที่ออกแบบมาเพื่อการเล่นเกมโดยเฉพาะ มาพร้อมคุณสมบัติเด่นอย่าง อัตราการรีเฟรชสูง (120Hz–240Hz หรือมากกว่า) และ เวลาตอบสนองต่ำ (1ms) ช่วยให้ภาพเคลื่อนไหวลื่นไหลและแม่นยำ เหมาะสำหรับเกมที่ต้องการความเร็วและการตอบสนองฉับไว นอกจากนี้ยังรองรับเทคโนโลยีอย่าง G-Sync หรือ FreeSync เพื่อลดการฉีกขาดของภาพ (screen tearing) และบางรุ่นมาพร้อม พาเนล IPS, VA หรือ OLED ที่ให้สีสันคมชัดและมุมมองกว้าง ดีไซน์ตัวเครื่องมักมีขอบบาง ปรับความสูง ก้ม–เงย หรือหมุนได้ เพื่อความสบายในการใช้งานระยะยาว ทำให้ Gaming Monitor ไม่เพียงเพิ่มประสบการณ์การเล่นเกมให้ดียิ่งขึ้น แต่ยังเหมาะกับการดูหนังหรือทำงานด้านกราฟิกด้วย.''',
  },
  {
    "image": "assets/images/NoImage.jpg",
    "title": "PS5 Controller",
    "price": "0.00 บาท",
    "detail":
        '''PS5 Controller หรือที่เรียกว่า DualSense Wireless Controller เป็นจอยหลักของเครื่อง PlayStation 5 ที่มาพร้อมดีไซน์โค้งมนจับถนัดมือและสีทูโทนเป็นเอกลักษณ์ จุดเด่นสำคัญคือ Haptic Feedback ที่ให้แรงสั่นสมจริงตามสถานการณ์ในเกม และ Adaptive Triggers ที่ทำให้ปุ่ม L2/R2 มีแรงต้านแตกต่างกัน เช่น การดึงคันธนูหรือการเหยียบคันเร่ง เพิ่มอรรถรสการเล่นเกมอย่างมีมิติ จอยยังมี ไมโครโฟนในตัว, ลำโพง, ปุ่ม Create สำหรับแชร์ประสบการณ์เกม และ พอร์ตชาร์จ USB-C พร้อมแบตเตอรี่ในตัว ใช้งานได้ทั้งกับ PS5, พีซี และสมาร์ตโฟน ทำให้ DualSense เป็นหนึ่งในจอยเกมที่ล้ำสมัยที่สุดในปัจจุบัน. ''',
  },
];
final List<Map<String, String>> colorPro = [
  {"color": "assets/images/Rectangle 8.png"},
  {"color": "assets/images/Rectangle 13.png"},
  {"color": "assets/images/Rectangle 14.png"},
  {"color": "assets/images/Rectangle 15.png"},
];
List<Map<String, String>> pay = [
  {"pay": "เงินสด", "value": "cash"},
  {"pay": "พร้อมเพลย์", "value": "promptpay"},
  {"pay": "บัตรเครดิต", "value": "credit"},
];

List<Map<String, String>> orderbill = [
  {"productname": "Airpods pro", "pice": "0.00","qty":"1","discount":"0.00","total":"0.00"},
   {"productname": "Aestheic Mug - white", "pice": "0.00","qty":"1","discount":"0.00","total":"0.00"},
 {"productname": "Gaming Monitor", "pice": "0.00","qty":"1","discount":"0.00","total":"0.00"},
];

String? selectedPay = "cash"; // ค่าเริ่มต้น