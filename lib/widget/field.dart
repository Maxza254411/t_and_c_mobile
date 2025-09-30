import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_and_c_mobile/constang.dart';

class RegisTextFormField extends StatefulWidget {
  RegisTextFormField({
    super.key,
    required this.size,
    this.controller,
    this.isPassword = false,
    this.hintText,
    required this.heights,
    this.fontsize,
    required this.width,
  });

  final Size size;
  TextEditingController? controller;
  final bool isPassword;
  String? hintText;
  double heights;
  double? fontsize;
  double? width;

  @override
  State<RegisTextFormField> createState() => _RegisTextFormFieldState();
}

class _RegisTextFormFieldState extends State<RegisTextFormField> {
  late bool _show = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onTap: () async {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      },
      style: TextStyle(fontSize: widget.fontsize ?? 22),
      obscureText: widget.isPassword ? _show : false,
      decoration: InputDecoration(
        filled: true, 
        fillColor: const Color.fromARGB(255, 241, 241, 241), 
        hintText: widget.hintText,

        hintStyle: const TextStyle(
          fontSize: 18,
          fontFamily: 'IBMPlexSansThai',
          color: kbgM,
        ),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _show = !_show;
                  });
                },
                child: _show
                    ? Image.asset('assets/icons/Eye.png', scale: 20)
                    : Image.asset('assets/icons/EyeSlash.png', scale: 20),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kButtonColor, width: 2),
        ),
      ),
    );
  }
}

class InputTextFormField extends StatefulWidget {
  InputTextFormField({
    super.key,
    required this.size,
    this.hintText,
    this.controller,
    required this.heights,
    required this.width,
    this.validator,
    this.images,
    required this.imagestatus,
    required this.whatfield,
    this.maxLines,
    this.fontsize,
    this.labelText,
  });

  final Size size;
  TextEditingController? controller;
  String? hintText;
  double heights;
  double width;
  String? images;
  bool imagestatus;
  bool whatfield;
  double? fontsize;
  int? maxLines;
  String? Function(String?)? validator;
  String? labelText;

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  @override
  Widget build(BuildContext context) {
    return widget.whatfield == true
        ? TextFormField(
            maxLines: widget.maxLines,
            controller: widget.controller,
            validator: widget.validator,
            style: TextStyle(fontSize: widget.fontsize ?? 22),
            decoration: InputDecoration(
              filled: true, // ทำให้พื้นหลังสีตาม fillColor
              fillColor: const Color.fromARGB(255, 241, 241, 241), // สีพื้นหลัง
              hintText: widget.hintText,
              labelText: widget.labelText,
              hintStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'IBMPlexSansThai',
                color: kbgM,
              ),
              labelStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'IBMPlexSansThai',
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kButtonColor, width: 2),
              ),
            ),
          )
        : TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            style: const TextStyle(fontSize: 22),
            decoration: InputDecoration(
              prefixIcon: widget.imagestatus == true
                  ? Image.asset(widget.images!, scale: 20)
                  : SizedBox.shrink(),

              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 18,
                fontFamily: 'IBMPlexSansThai',
                color: kbgM,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: kButtonColor, width: 2),
              ),
            ),
          );
  }
}
