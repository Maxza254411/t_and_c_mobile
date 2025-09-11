import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/login.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';

class Profile extends StatefulWidget {
   Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/icons/Notification.png", scale: 15),
          ),
        ],
        title: Text(
          "โปรไฟล์",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: size.width,
                height: size.height * 0.22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                  
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: kButtonColor,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// ไอคอน + ชื่อผู้ใช้
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: kbgf,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "admin admin",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BoxProfile(
              size: size,
              title: 'ชื่อผู้ใช้',
              description: 'admin admin',
            ),
            BoxProfile(
              size: size,
              title: 'Member Id',
              description: '000-000-0000',
            ),
            BoxProfile(
              size: size,
              title: 'รหัสประจำตัวผู้ใช้(User Id)',
              description: '***************',
            ),
            BoxProfile(
              size: size,
              title: 'เบอร์มือถือ',
              description: '000-xxx-xxxx',
            ),
            BoxProfile(
              size: size,
              title: 'วิธีการชำระเงินหลัก',
              description: 'เงินสด',
              status: true,
            ),

            GestureDetector(
              onTap: () async {
                final out = await showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => AlertDialogYesNo(
                    description: 'คุณต้องการออกจากระบบหรือไม่',
                    title: 'แจ้งเตือน',
                  ),
                );
                if (out == true) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Loginpage()),
                    (route) => false,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.08,
                  decoration: BoxDecoration(
                    color: kButtonColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "ออกจากระบบ",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxProfile extends StatelessWidget {
  BoxProfile({
    super.key,
    required this.size,
    required this.title,
    required this.description,
    this.status = false,
  });

  final Size size;
  String title;
  String description;
  bool? status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kButtonColor,
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              padding: EdgeInsets.all(12),
              height: size.height * 0.1,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kButtonColor,
                        ),
                      ),
                      status == false
                          ? SizedBox.shrink()
                          : Container(
                              height: size.height * 0.04,

                              width: size.width * 0.15,
                              decoration: BoxDecoration(
                                color: kButtonColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "เเก้ไข",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
