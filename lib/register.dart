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
      appBar: AppBar(
          backgroundColor: kButtonColor,
  iconTheme: IconThemeData(
              color: Colors.white
            ),
            title: Text("ติดต่อเรา",style: TextStyle(color: Colors.white),),
      ),
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
                SizedBox(height: size.height * 0.1),
                
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
                        "ติดต่อเรา",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "หากทานมีปัญหาเกี่ยวกับการใช้งานระบบหรือต้องการสอบถามข้อมูลเพิ่มเติม",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "(เวลาทำการ จันทร์-ศุกร์ 9:00-18:00 น.)",
                        style: TextStyle(
                          color: const Color.fromARGB(253, 119, 118, 118),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "ติดต่อแอดมิน",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "095-712-7848",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kButtonColor,
                        ),
                      ),
                            SizedBox(height: 10),
                      Text(
                        "หรือ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: size.height * 0.05),
                         Column(
                           children: [
                           
                             Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.green,)),
                               child: Column(
                                 children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/icons/LINE_Brand_icon 2 1.png",scale: 20,),
                                        Text("  Line Official Account",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                      ],
                                    ),
                                  ),
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Center(
                                       child: SizedBox(
                                                         height: size.height * 0.3,
                                                         child: Image.asset("assets/images/QrLineOf.png"),
                                                       ),
                                     ),
                                   ),
                                 ],
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
