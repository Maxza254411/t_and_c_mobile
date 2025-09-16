import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/fristPage.dart';
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
                        controller: password,
                        size: size,
                        isPassword: true,
                        heights: size.height * 0.05,
                        fontsize: 16,
                        width: double.infinity,
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            activeColor: kButtonColor,
                            value: _isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value ?? false;
                              });
                            },
                          ),
                          Text('Remember me'),
                          SizedBox(width: size.width * 0.1),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(color: kButtonColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString("token", _login["token"]);
                            await prefs.setInt("userId", _login["user"]["id"]);
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
                           
                          }
                  

                          LoadingDialog.close(context);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Loginpage()), (route) => false);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => FirstPage(),
                          //   ),
                          // );
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
                   child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ktextColr,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: size.width * 0.9,
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
