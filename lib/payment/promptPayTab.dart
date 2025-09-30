import 'dart:async';
import 'package:flutter/material.dart';

// import 'package:image_gallery_saver/image_gallery_saver.dart';

class PromptPayTab extends StatefulWidget {
  const PromptPayTab({super.key});

  @override
  _PromptPayTabState createState() => _PromptPayTabState();
}

class _PromptPayTabState extends State<PromptPayTab> {
  int secondsRemaining = 600; // 10 นาที
  late Timer timer;
  // ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // Future<void> saveQrToGallery() async {
  //   final image = await screenshotController.capture();
  //   if (image != null) {
  //     final result = await ImageGallerySaver.saveImage(
  //       Uint8List.fromList(image),
  //       quality: 100,
  //       name: "promptpay_qr",
  //     );
  //     if (result["isSuccess"]) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("บันทึกรูปภาพเรียบร้อยแล้ว")),
  //       );
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // นับถอยหลัง
          Text(
            "เวลาที่เหลือ: ${formatTime(secondsRemaining)}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),

          // QR Code พร้อมเพย์
          // Screenshot(
          //   controller: screenshotController,
          //   child: QrImageView(
          //     data: "00020101021129370016A0000006770101110212345678905802TH53037646304A1B2", 
          //     version: QrVersions.auto,
          //     size: 200.0,
          //   ),
          // ),

          const SizedBox(height: 20),

          // ปุ่มบันทึกรูปภาพ
          // ElevatedButton.icon(
          //   onPressed: saveQrToGallery,
          //   icon: const Icon(Icons.download),
          //   label: const Text("บันทึกรูปภาพ"),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.green,
          //     foregroundColor: Colors.white,
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
