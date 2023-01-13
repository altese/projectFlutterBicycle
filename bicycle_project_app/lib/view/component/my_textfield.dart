import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final keyboardType;
  final bool autofocus;
  final icon;
  final color;

  const MyTextfield({
    super.key,
    this.controller,
    this.keyboardType,
    this.icon,
    this.color,
    required this.hintText,
    required this.obscureText,
    required this.autofocus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autofocus: autofocus,
        decoration: InputDecoration(
          //선택 비선택시 테두리색깔
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 110, 173, 143),
            ),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon: icon,
          suffixIconColor: color,
        ),
      ),
    );
  }
}
