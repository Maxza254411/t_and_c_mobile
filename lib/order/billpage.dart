// import 'package:flutter/material.dart';
// import 'package:t_and_c_mobile/constang.dart';

// class BillPage extends StatefulWidget {
//   BillPage({super.key});

//   @override
//   State<BillPage> createState() => _BillPageState();
// }

// class _BillPageState extends State<BillPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[300],
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: kButtonColor,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.chevron_left, color: Colors.white),
//         ),
//         actions: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Image.asset("assets/icons/Notification.png", scale: 15),
//           ),
//         ],
//         centerTitle: true,
//         title: Text(
//           "ใบเสร็จ",
//           style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                 child: Container(
//                   width: 380,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     border: Border.all(color: Colors.black12),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: const [
//                               Text(
//                                 "Ordered By",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                               SizedBox(height: 4),
//                               Text(
//                                 "Admin Admin",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text("1456 Veltri Drive,\nAnchorage, AK 99502"),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 "assets/images/LOGO CMYK-01.png",
//                                 scale: 30,
//                               ),

//                               Text(
//                                 "บริษัทT&Cจำกัด",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12),

//                       // Order Details
//                       Divider(),
//                       Text(
//                         "Order Details",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: kButtonColor,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("ชื่อ : Product name"),
//                                 Text("Order Date : 24/12/2022"),
//                                 Text("Order ID : #56452568"),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: 12),
//                       Divider(),

//                       // Table Header
//                       Row(
//                         children: const [
//                           Expanded(flex: 2, child: Text("ชื่อสินค้า")),
//                           Expanded(child: Text("ราคา")),
//                           Expanded(child: Text("จำนวน")),
//                           Expanded(child: Text("ส่วนลด")),
//                           Expanded(child: Text("รวม")),
//                         ],
//                       ),
//                       const Divider(),

//                       // Table Rows
//                       Column(
//                         children: List.generate(
//                           orderbill.length,
//                           (index) => Row(
//                             children: [
//                               Expanded(
//                                 flex: 2,
//                                 child: Text(orderbill[index]["productname"]!),
//                               ),
//                               Expanded(child: Text(orderbill[index]["pice"]!)),
//                               Expanded(child: Text(orderbill[index]["qty"]!)),
//                               Expanded(
//                                 child: Text(orderbill[index]["discount"]!),
//                               ),
//                               Expanded(child: Text(orderbill[index]["total"]!)),
//                             ],
//                           ),
//                         ),
//                       ),

//                       Divider(),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: const [
//                           Text(
//                             "จำนวนรวมทั้งหมด ",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             "0.00 บาท",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(),

//                       // Footer
//                       Row(
//                         children: const [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Sold By",
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   "สถานที่จัดส่ง",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   '''123/45 ถนนสุขุมวิท 55 แขวงคลองตันเหนือ เขตวัฒนา กรุงเทพมหานคร 10110 โทร. 02-123-4567''',
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Delivered To",
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 Text(
//                                   "ส่งถึง",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   "99/123 หมู่บ้านสุขใจ ถนนประชาร่วมใจ แขวงบางกะปิ เขตห้วยขวาง กรุงเทพมหานคร 10310",
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12),
//                       Divider(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
