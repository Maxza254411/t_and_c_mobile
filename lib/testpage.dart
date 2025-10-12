import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int currentStep = 1; // เปลี่ยนเป็น 0,1,2 ตามสถานะปัจจุบัน

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("สถานะการขนส่ง"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DeliveryStatusBar(currentStep: currentStep),
             SizedBox(height: 40),
            // ปุ่มทดสอบเปลี่ยนสถานะ
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentStep = (currentStep + 1) % 3; // สลับสถานะ
                });
              },
              child: const Text("ถัดไป"),
            )
          ],
        ),
      ),
    );
  }
}

class DeliveryStatusBar extends StatelessWidget {
  final int currentStep; // 0 = เตรียมสินค้า, 1 = กำลังจัดส่ง, 2 = ถึงปลายทาง

  const DeliveryStatusBar({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = ["เตรียมสินค้า", "กำลังจัดส่ง", "ถึงปลายทาง"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          int stepIndex = index ~/ 2;
          bool isActive = stepIndex <= currentStep;
          return Column(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: isActive ? Colors.green : Colors.grey,
                child: Icon(
                  isActive ? Icons.check : Icons.circle,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[stepIndex],
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          );
        } else {
          int lineIndex = (index - 1) ~/ 2;
          bool isActive = lineIndex < currentStep;
          return Expanded(
            child: Container(
              height: 3,
              color: isActive ? Colors.green : Colors.grey[300],
            ),
          );
        }
      }),
    );
  }
}
