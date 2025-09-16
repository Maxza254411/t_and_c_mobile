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
    return Container(
        decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 241, 241, 241),
              
            ),
              width: widget.width,
            height: widget.heights,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextFormField(
          
          controller: widget.controller,
          onTap: () async {
            await SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.immersiveSticky,
            );
          },
              style: TextStyle(fontSize: widget.fontsize ?? 22),
          obscureText: widget.isPassword ? _show : false,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: widget.hintText,
            
        
             hintStyle: const TextStyle(
                    fontSize: 15,
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
          ),
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

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  @override
  Widget build(BuildContext context) {
    return widget.whatfield == true
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 241, 241, 241),
            ),
            width: widget.width,
            height: widget.heights,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                maxLines: widget.maxLines,
                controller: widget.controller,
                validator: widget.validator,
                style: TextStyle(fontSize: widget.fontsize ?? 22),
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'IBMPlexSansThai',
                    color: kbgM,
                  ),
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 241, 241, 241),
            ),
            width: double.infinity,
            height: widget.heights,
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              style: const TextStyle(fontSize: 22),
              decoration: InputDecoration(
                prefixIcon: widget.imagestatus == true
                    ? Image.asset(widget.images!, scale: 20)
                    : SizedBox.shrink(),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'IBMPlexSansThai',
                  color: kbgM,
                ),
              ),
            ),
          );
  }
}
