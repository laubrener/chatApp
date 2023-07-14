import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput(
      {super.key,
      this.icon,
      required this.placeholder,
      required this.textController,
      this.keyboardType,
      this.isPassword});
  final IconData? icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType? keyboardType;
  final bool? isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5),
          ],
          color: Colors.white,
        ),
        child: TextField(
          controller: textController,
          autocorrect: false,
          keyboardType: keyboardType,
          obscureText: false,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: placeholder,
          ),
        ));
  }
}
