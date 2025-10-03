import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';
import 'package:t_and_c_mobile/model/address.dart';


class AddressPage extends StatefulWidget {
  AddressPage({super.key, required this.address});
  List<Address> address = [];

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  int? selectedAddress; // เก็บ index ของที่อยู่ที่เลือก

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kbgH,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          "ที่อยู่",
          style: TextStyle(color: kbgf, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.address.length,
              itemBuilder: (context, index) {
                final address = widget.address[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: kButtonColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.full_th_address ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Radio<int>(
                        value: index,
                        groupValue: selectedAddress,
                        onChanged: (value) {
                          setState(() {
                            selectedAddress = value;
                          });
                        },
                        activeColor: kButtonColor,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: size.height * 0.05, // ความสูง
              width: size.width * 1, // ความ
              child: ElevatedButton(
                onPressed: selectedAddress == null
                    ? null
                    : () {
                        // ✅ ส่ง object ทั้งตัวกลับ
                        Navigator.pop(context, {
                          "addressid":
                              widget.address[selectedAddress!].id,
                          "full_th_address":
                              widget.address[selectedAddress!].full_th_address,
                        });
                      },
                style: ElevatedButton.styleFrom(backgroundColor: kButtonColor),
                child: const Text(
                  "ยืนยัน",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
