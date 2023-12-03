import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final bool obscure;
  final TextInputType keyboardType;
  const InputField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.prefixIcon,
      required this.obscure,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          suffixIcon: GestureDetector(
            child: const Icon(
              Icons.clear,
              color: Colors.black,
              size: 20,
            ),
            onTap: () => controller.clear(),
          ),
          filled: true,
          fillColor: Colors.white),
    );
  }
}
