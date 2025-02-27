import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  const Button({
    super.key,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          elevation: 10,
          backgroundColor: Colors.blue[100],
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          side: const BorderSide(
              color: Colors.black, width: 1, style: BorderStyle.solid),
        ),
        onPressed: ontap,
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
        ));
  }
}
