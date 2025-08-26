import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/widget/field.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  bool _isChecked = false;
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
    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
    
        children: [
          SizedBox(height: size.height*0.05,
          ),
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
                Text("Username"),
                SizedBox(height: size.height * 0.01),
                InputTextFormField(
                  size: size,
                  heights: size.height * 0.05,
                ),
                Text("Password"),
                SizedBox(height: size.height * 0.01),
                RegisTextFormField(
                  size: size,
                  isPassword: true,
                  heights: size.height * 0.05,
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                    ),
                    Text('Remember me'),
                    SizedBox(width: size.width * 0.15),
                    Text('Forgot Password ?'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ktextColr,
                borderRadius: BorderRadius.circular(12),
              ),
              width: size.width * 0.9,
              child: Center(child: Text("Login",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:Colors.white) ,)),
            ),
          ),
        ],
      ),
    ),
  ),
);

  }
}
