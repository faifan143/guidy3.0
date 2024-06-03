import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReusableFormField extends StatelessWidget {
  ReusableFormField({
    Key? key,
    this.label,
    this.hint,
    this.keyType,
    this.controller,
    this.onTap,
    this.onTyping,
    required this.isPassword,
    required this.icon,
    required this.checkValidate,
  }) : super(key: key);
  final String? label;
  final String? hint;
  bool isPassword = false;
  final TextInputType? keyType;
  final TextEditingController? controller;
  Widget icon;
  VoidCallback? onTap;
  String? Function(String?)? checkValidate;
  void Function(String)? onTyping;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: checkValidate,
      keyboardType: keyType,
      obscureText:  isPassword == false ? false : true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderSide:  BorderSide(width: 1.w),
            borderRadius: BorderRadius.circular(10)),
        label: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(label!)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        prefixIcon: IconButton(onPressed: onTap, icon: icon),
        hintText: hint,
      ),
      onChanged: (value) => onTyping != null ? onTyping!(value) : {},
    );
  }
}
