import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _isChecked = false;

  //ฟังชั่นดักอีเมล
  bool validateEmail(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text("กรุณากรอกอีเมล"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ตกลง"),
            ),
          ],
        ),
      );
      return false;
    }

    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialogYes(
          title: 'แจ้งเตือน',
          description: 'รูปแบบอีเมลไม่ถูกต้อง',
          pressYes: () {
            Navigator.pop(context);
          },
        ),
      );
      return false;
    }

    return true; // ✅ ผ่าน
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, kButtonColor],
          ),
        ),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),

          child: Form(
            // key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.01),
                SizedBox(
                  height: size.height * 0.3,
                  child: Image.asset("assets/images/LOGO CMYK-01.png"),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kbgf,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "สมัครสมาชิก",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "ลงทะเบียนกับ TNC Partner สั่งซื้อง่าย ครบในที่เดียว\nพร้อมรับสิทธิประโยชน์และกิจกรรมอีกมากมาย",
                        style: TextStyle(color: kbgM),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("เคยลงทะเบียนแล้ว? "),
                          GestureDetector(
                            onTap: () {
                             Navigator.pop(context);
                            },
                            child: Text(
                              "เข้าสู่ระบบ",
                              style: TextStyle(color: kButtonColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),

                      InputTextFormField(
                        labelText: "รหัสร้านค้า",
                        controller: email,
                        size: size,
                        heights: size.height * 0.05,
                        imagestatus: false,
                        whatfield: true,
                        width: double.infinity,
                        fontsize: 16,
                      ),
                      SizedBox(height: size.height * 0.01),
                      InputTextFormField(
                        labelText: "ชื่อ-นามสกุล ผู้รับ",
                        controller: email,
                        size: size,
                        heights: size.height * 0.05,
                        imagestatus: false,
                        whatfield: true,
                        width: double.infinity,
                        fontsize: 16,
                      ),
                      SizedBox(height: size.height * 0.01),
                      InputTextFormField(
                        labelText: "ชื่อร้าน",
                        controller: email,
                        size: size,
                        heights: size.height * 0.05,
                        imagestatus: false,
                        whatfield: true,
                        width: double.infinity,
                        fontsize: 16,
                      ),
                      SizedBox(height: size.height * 0.01),
                      InputTextFormField(
                        labelText: "เบอร์โทรศัพท์",
                        controller: email,
                        size: size,
                        heights: size.height * 0.05,
                        imagestatus: false,
                        whatfield: true,
                        width: double.infinity,
                        fontsize: 16,
                      ),
                      SizedBox(height: size.height * 0.03),
                      GestureDetector(
                        onTap: () async {
                          // if (validateEmail(context, email.text)) {
                          //   if (password.text == '' || email.text == '') {
                          //     await showDialog(
                          //       barrierDismissible: false,
                          //       context: context,
                          //       builder: (context) => AlertDialogYes(
                          //         title: 'แจ้งเตือน',
                          //         description: 'กรูณากรอกข้อมูล',
                          //         pressYes: () {
                          //           Navigator.pop(context);
                          //         },
                          //       ),
                          //     );
                          //   } else {
                          //     try {
                          //       LoadingDialog.open(context);
                          //       final _login = await LoginApi.login(
                          //         email.text,
                          //         password.text,
                          //       );
                          //       if (_login["token"] != null) {
                          //         final prefs =
                          //             await SharedPreferences.getInstance();
                          //         await prefs.setString(
                          //           "token",
                          //           _login["token"],
                          //         );
                          //         await prefs.setInt(
                          //           "userId",
                          //           _login["user"]["id"],
                          //         );
                          //         await prefs.setString(
                          //           "first_name",
                          //           _login["user"]["first_name"],
                          //         );
                          //         await prefs.setString(
                          //           "last_name",
                          //           _login["user"]["last_name"],
                          //         );
                          //         await prefs.setString(
                          //           "staff_code",
                          //           _login["user"]["staff_code"],
                          //         );
                          //         await prefs.setString(
                          //           "email",
                          //           _login["user"]["email"],
                          //         );
                          //       }

                          //       LoadingDialog.close(context);
                          //       Navigator.pushAndRemoveUntil(
                          //         context,
                          //         MaterialPageRoute(
                          //           builder: (context) => FirstPage(),
                          //         ),
                          //         (route) => false,
                          //       );

                          //     } on Exception catch (e) {
                          //       if (!mounted) return;
                          //       LoadingDialog.close(context);
                          //       await showDialog(
                          //         barrierDismissible: false,
                          //         context: context,
                          //         builder: (context) => AlertDialogYes(
                          //           title: 'แจ้งเตือน',
                          //           description: '$e',
                          //           pressYes: () {
                          //             Navigator.pop(context);
                          //           },
                          //         ),
                          //       );
                          //     }
                          //   }
                          // }
                        },

                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kButtonColor,
                              borderRadius: BorderRadius.circular(12),
                            ),

                            height: size.height * 0.06,
                            child: Center(
                              child: Text(
                                "ยืนยัน",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                       SizedBox(height: size.height * 0.01),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        
                          height: size.height * 0.06,
                          child: Center(
                            child: Text(
                              "ย้อนกลับ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kButtonColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
