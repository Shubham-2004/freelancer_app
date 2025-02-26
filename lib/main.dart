import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_app/Pages/login.dart';
import 'package:freelancer_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Freelanver application',
      home: Login(),
    ),
  );
}
