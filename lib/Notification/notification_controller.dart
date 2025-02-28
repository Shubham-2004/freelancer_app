import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class NotificationController extends StatefulWidget {
   NotificationController({super.key});

  @override
  State<NotificationController> createState() => _NotificationControllerState();
}

class _NotificationControllerState extends State<NotificationController> {
  final Toastification toastification = Toastification();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            toastification.show(
              title: Text("THIS IS THE DEMO NotificationController"),
              type: ToastificationType.success,
              style: ToastificationStyle.flat,
              autoCloseDuration: const Duration(seconds: 10),
            );
          },
          child: Text("Show notificaton"),
        ),
      ),
    );
  }
}

