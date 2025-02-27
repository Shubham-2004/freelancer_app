
import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final IconData icon;
  final bool obstext;

  const Textfield({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.icon,
    required this.obstext,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autocorrect: true,
      obscureText: obstext,
      decoration: InputDecoration(
        
          hintText: hinttext,
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: Icon(icon),
          alignLabelWithHint: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey[100]!, width: 1))),
    );
  }
}
