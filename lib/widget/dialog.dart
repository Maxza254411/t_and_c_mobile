import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:t_and_c_mobile/constang.dart';

class AlertDialogYes extends StatefulWidget {
  AlertDialogYes({
    Key? key,
    required this.description,
    required this.pressYes,
    required this.title,
    this.fontsize,
    InkWell? onTap,
  }) : super(key: key);
  final String title, description;
  final VoidCallback? pressYes;
  double? fontsize;

  @override
  State<AlertDialogYes> createState() => _AlertDialogYesState();
}

class _AlertDialogYesState extends State<AlertDialogYes> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: kbgf,
      title: Center(
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      content: Text(
        widget.description,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        GestureDetector(
          onTap: widget.pressYes,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kButtonColor,
            ),
            height: size.height * 0.07,
            width: size.width * 0.2,
            child: Center(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SucesDialog extends StatefulWidget {
  const SucesDialog({
    Key? key,
    required this.description,
    required this.title,
    this.fontsize,
  }) : super(key: key);

  final String title, description;
  final double? fontsize;

  @override
  State<SucesDialog> createState() => _SucesDialogState();
}

class _SucesDialogState extends State<SucesDialog> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: Colors.white,

      // ทำให้กล่องเล็กลง
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      title: Image.asset("assets/icons/Group.png", scale: 4),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 280, maxHeight: 220),
        child: Text(
          widget.description,
          style: TextStyle(
            fontSize: widget.fontsize ?? 16,
            fontWeight: FontWeight.w600, // ทำให้ตัวหนา
          ),
          textAlign: TextAlign.center,
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green,
            ),
            height: size.height * 0.055, // ลดความสูงให้กะทัดรัด
            width: size.width * 0.4, // ปุ่มไม่เต็มจอ
            child: const Center(
              child: Text(
                'ปิดหน้าต่าง',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
