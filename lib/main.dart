import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_app/Pages/Homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freelancer_app/Pages/login.dart';
import 'package:freelancer_app/chat_service/pages/home.dart';
import 'package:freelancer_app/presentation/screens/onboarding/splash_screen.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Sphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode:
          ThemeMode
              .system, // Automatically switch between light and dark themes
      // added the stream bulder to notify the user the login and logout activities
      home: StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          return SplashScreen();
          // if (snapshot.hasData) {
          //   return Homepage();
          // } else {
          //   return SplashScreen();
          // }
        },
      ),
    );
  }
}
