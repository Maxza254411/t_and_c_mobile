import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
import 'package:t_and_c_mobile/register.dart';
import 'package:t_and_c_mobile/serviceLogin/loginApi.dart';
import 'package:t_and_c_mobile/widget/dialog.dart';
import 'package:t_and_c_mobile/widget/field.dart';
import 'package:t_and_c_mobile/widget/loadingdialog.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
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

  Future<void> setupLineSDK() async {
    await LineSDK.instance.setup("2008197121");
    print("LINE SDK is ready");
  }

  Future<void> loginWithLine() async {
    try {
      // Login และขอ scope profile + openid (email ต้องขออนุมัติ)
      final result = await LineSDK.instance.login(
        scopes: ["profile", "openid"],
      );

      // ดึงข้อมูลผู้ใช้
      final user = result.userProfile;
      final accessToken = result.accessToken.value;

      print("Login Success!");
      print("Display Name: ${user?.displayName}");
      print("User ID: ${user?.userId}");
      print("Profile Picture: ${user?.pictureUrl}");
      print("Access Token: $accessToken");

      // TODO: เอา accessToken ไปเรียก API หรือเก็บไว้ใน app ตามต้องการ
    } catch (e) {
      print("Login failed: $e");
    }
  }

  Future<void> logoutLine() async {
    try {
      await LineSDK.instance.logout();
      print("Logout success");
    } catch (e) {
      print("Logout failed: $e");
    }
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
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SizedBox(height: size.height * 0.05),
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
                      SizedBox(height: size.height * 0.01),
                      Text("Email"),

                      InputTextFormField(
                        hintText: "Email address ",
                        controller: email,
                        size: size,
                        heights: size.height * 0.05,
                        imagestatus: false,
                        whatfield: true,
                        width: double.infinity,
                        fontsize: 16,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text("Password"),

                      RegisTextFormField(
                        hintText: "Password ",
                        controller: password,
                        size: size,
                        isPassword: true,
                        heights: size.height * 0.05,
                        fontsize: 16,
                        width: double.infinity,
                      ),
                      SizedBox(height: size.height * 0.01),
                      
                      GestureDetector(
                        onTap: () async {
                          if (validateEmail(context, email.text)) {
                            if (password.text == '' || email.text == '') {
                              await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => AlertDialogYes(
                                  title: 'แจ้งเตือน',
                                  description: 'กรูณากรอกข้อมูล',
                                  pressYes: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            } else {
                              try {
                                LoadingDialog.open(context);
                                final _login = await LoginApi.login(
                                  email.text,
                                  password.text,
                                );
                                if (_login["token"] != null) {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                    "token",
                                    _login["token"],
                                  );
                                  await prefs.setInt(
                                    "userId",
                                    _login["user"]["id"],
                                  );
                                  await prefs.setString(
                                    "first_name",
                                    _login["user"]["first_name"],
                                  );
                                  await prefs.setString(
                                    "last_name",
                                    _login["user"]["last_name"],
                                  );
                                  await prefs.setString(
                                    "staff_code",
                                    _login["user"]["staff_code"],
                                  );
                                  await prefs.setString(
                                    "email",
                                    _login["user"]["email"],
                                  );
                                  await prefs.setString(
                                    "user_type",
                                    _login["user"]["user_type"],
                                  );
                                  
                                  if ( _login["user"]["tel_no"]!=null) {                                    
                                  await prefs.setString(
                                    "tel_no",
                                    _login["user"]["tel_no"],
                                  );
                                  }else{
                                    print("เบอร์โทรเป็น null");
                                  }
                                }

                                LoadingDialog.close(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FirstPage(),
                                  ),
                                  (route) => false,
                                );
                              } on Exception catch (e) {
                                if (!mounted) return;
                                LoadingDialog.close(context);
                                await showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => AlertDialogYes(
                                    title: 'แจ้งเตือน',
                                    description: '$e',
                                    pressYes: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              }
                            }
                          }
                        },

                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: ktextColr,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            // width: size.width * 0.7,
                            height: size.height * 0.06,
                            child: Center(
                              child: Text(
                                "Login",
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
                      SizedBox(height: size.height * 0.02),
                      Center(child: Text("---------- หรือ ----------")),
                      SizedBox(height: size.height * 0.02),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            await loginWithLine();
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kline,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            // width: size.width * 0.7,
                            height: size.height * 0.06,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/icons/LINE_Brand_icon 2 1.png",
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "เข้าสู่ระบบผ่าน Line",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(),
                                ),
                              );
                            },
                            child: Text(
                              "ติดต่อเรา",
                              style: TextStyle(color: kButtonColor,fontSize: 20),
                            ),
                          ),
                        ],
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
