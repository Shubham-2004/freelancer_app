import 'package:flutter/material.dart';
import 'package:freelancer_app/chat_service/components/button.dart';

Future<void> dailog(
    String text, BuildContext context, VoidCallback ontap) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        elevation: 4,
        backgroundColor: Colors.grey[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Alert',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          Column(
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Button(text: "Okay", ontap: ontap),
              )
            ],
          ),
        ],
      );
    },
  );
}
