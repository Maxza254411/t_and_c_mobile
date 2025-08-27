import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:t_and_c_mobile/constang.dart';


class AlertDialogYesNo extends StatefulWidget {
  AlertDialogYesNo({
    Key? key,
    required this.description,
    required this.pressYes,
    required this.title,
    required this.pressNo,
    required this.orderNo,
  }) : super(key: key);
  final String title, description, orderNo;
  final VoidCallback pressYes;
  final VoidCallback pressNo;

  @override
  State<AlertDialogYesNo> createState() => _AlertDialogYesNoState();
}

class _AlertDialogYesNoState extends State<AlertDialogYesNo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: kbgf,
      title: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      content: Text(
        '${widget.description} ${widget.orderNo}',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return kbgf;
                        }
                        return kbgf;
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.white; // สีข้อความเมื่อปุ่มถูกปิดใช้งาน
                        }
                        return Colors.blue; // สีข้อความเมื่อปุ่มสามารถใช้งานได้
                      },
                    ),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Colors.white.withOpacity(0.04);
                        }
                        if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                          return Colors.blue.withOpacity(0.12); // สีทับเมื่อปุ่มถูกกดหรือโฟกัส
                        }
                        return null;
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.blue), // สีขอบของปุ่ม
                      ),
                    ),
                  ),
                  onPressed: widget.pressNo,
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return kButtonColor;
                      }
                      return kButtonColor;
                    },
                  ),
                ),
                onPressed: widget.pressYes,
                child: Text(
                  'ตกลง',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AlertDialogTAPCard extends StatelessWidget {
  AlertDialogTAPCard({Key? key, required this.description, this.pressYes, required this.title, this.iconsincorrect}) : super(key: key);
  final String title, description;
  final VoidCallback? pressYes;
  final String? iconsincorrect;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: kbgf, // ตรวจสอบว่ามีการกำหนดค่า kTextButtonColor แล้ว
      title: Center(
          child: Image.asset(
        iconsincorrect ?? "",
        scale: 10,
      )),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0), // เพิ่ม padding ให้ข้อความไม่ชิดขอบ
        child: Text(
          description,
          style: TextStyle(
            fontSize: 20, // ลดขนาดตัวอักษรลงเล็กน้อยเพื่อความสมดุล
          ),
          textAlign: TextAlign.center, // ตั้งค่าการจัดตำแหน่งข้อความให้อยู่ตรงกลาง
        ),
      ),
      actionsAlignment: MainAxisAlignment.center, // ปรับการจัดตำแหน่งของปุ่มให้อยู่กลาง
      actions: [
        GestureDetector(
          onTap: pressYes,
          child: Text(
            'ตกลง',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kbgf, // ตรวจสอบว่ามีการกำหนดค่า kButtoncolor แล้ว
            ),
          ),
        ),
      ],
    );
  }
}

class AlertDialogYes extends StatefulWidget {
  AlertDialogYes({Key? key, required this.description, required this.pressYes, required this.title, InkWell? onTap}) : super(key: key);
  final String title, description;
  final VoidCallback? pressYes;

  @override
  State<AlertDialogYes> createState() => _AlertDialogYesState();
}

class _AlertDialogYesState extends State<AlertDialogYes> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: kbgf, // ตรวจสอบว่ามีการกำหนดค่า kTextButtonColor แล้ว
      title: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 20, // ปรับขนาดใหญ่ขึ้นเล็กน้อยเพื่อความเด่นชัด
            fontWeight: FontWeight.bold, // เพิ่มความหนาของตัวอักษรเพื่อความเด่นชัด
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0), // เพิ่ม padding ให้ข้อความไม่ชิดขอบ
        child: Text(
          widget.description,
          style: TextStyle(
            fontSize: 16, // ลดขนาดตัวอักษรลงเล็กน้อยเพื่อความสมดุล
          ),
          textAlign: TextAlign.center, // ตั้งค่าการจัดตำแหน่งข้อความให้อยู่ตรงกลาง
        ),
      ),
      actionsAlignment: MainAxisAlignment.center, // ปรับการจัดตำแหน่งของปุ่มให้อยู่กลาง
      actions: [
        GestureDetector(
          onTap: widget.pressYes,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:kButtonColor,
            ),
            height: size.height * 0.07,
            width: size.width * 0.2,
            child: Center(
              child: Text(
                'ตกลง',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}