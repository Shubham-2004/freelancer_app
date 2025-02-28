import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freelancer_app/client_side/pages/client_bottom_navigation.dart';
import 'package:freelancer_app/client_side/pages/client_home_page.dart';
import 'package:freelancer_app/presentation/screens/onboarding/splash_screen.dart';
import 'package:freelancer_app/utils/widget/bottom_navbar_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _showAnimation() async {
    await Future.delayed(const Duration(seconds: 3));
  }

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
      themeMode: ThemeMode.system,
      home: ClientBottomNavigation(),
      // home: FutureBuilder(
      //   future: _showAnimation(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Scaffold(
      //         body: Center(child: Image.asset('assets/images/animation.gif')),
      //       );
      //     } else {
      //       return StreamBuilder<User?>(
      //         stream: auth.authStateChanges(),
      //         builder: (context, snapshot) {
      //           return ClientBottomNavigation();
      //           // if (snapshot.hasData) {
      //           //   return BottomNavbarController();
      //           // } else {
      //           //   return SplashScreen();
      //           // }
      //         },
      //       );
      //     }
      //   },
      // ),
    );
  }
}
