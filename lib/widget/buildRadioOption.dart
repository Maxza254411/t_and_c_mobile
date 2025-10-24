import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';

class BuildRadioOption extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final Function(String?) onChanged;

  const BuildRadioOption({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = groupValue == value;
  final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        height: size.height*0.05,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ?kButtonColor: Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor:kButtonColor,
              onChanged: onChanged,
            ),
            SizedBox(
              width: size.width*0.25,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
