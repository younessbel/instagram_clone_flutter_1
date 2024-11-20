import 'package:flutter/material.dart';

class TextFieldeMine extends StatelessWidget {
  final String name;
  final TextInputType textInputTypee;
  final TextEditingController controller;
  final bool password;
  const TextFieldeMine(
      {super.key,
      required this.name,
      required this.controller,
      required this.password,
      required this.textInputTypee});

  @override
  Widget build(BuildContext context) {
    final InputBorder inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: controller,
      obscureText: password,
      keyboardType: textInputTypee,
      decoration: InputDecoration(
        hintText: name,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: EdgeInsets.all(8),
      ),
    );
  }
}
