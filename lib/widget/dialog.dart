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
    this. fontsize,
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
