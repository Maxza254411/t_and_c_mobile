import 'package:flutter/material.dart';
import 'package:t_and_c_mobile/constang.dart';

class BuildRadioOption extends StatefulWidget {
  final String title;
  final String value;
  final String? groupValue;
  final Function(String?) onChanged;
  final String typ;

  const BuildRadioOption({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged, 
    required this.typ,
  });

  @override
  State<BuildRadioOption> createState() => _BuildRadioOptionState();
}

class _BuildRadioOptionState extends State<BuildRadioOption> {
  @override
  Widget build(BuildContext context) {
    final bool isSelected = widget.groupValue == widget.value;
  final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => widget.onChanged(widget.value),
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
              value: widget.value,
              groupValue: widget.groupValue,
              activeColor:kButtonColor,
              onChanged: widget.onChanged,
            ),
            widget.typ=='color'
           ? SizedBox(
              width: size.width*0.25,
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: widget.typ=='color'? 10:16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
            )
            : Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
