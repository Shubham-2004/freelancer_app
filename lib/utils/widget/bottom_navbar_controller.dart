import 'package:flutter/material.dart';

import 'package:freelancer_app/Pages/Homepage.dart';
import 'package:freelancer_app/Pages/client_list.dart';
import 'package:freelancer_app/Pages/client_project_list.dart';
import 'package:freelancer_app/chat_service/pages/chat_list.dart';

class BottomNavbarController extends StatefulWidget {
  const BottomNavbarController({Key? key}) : super(key: key);

  @override
  State<BottomNavbarController> createState() => _BottomNavbarControllerState();
}

class _BottomNavbarControllerState extends State<BottomNavbarController> {
  int currentIndex = 0;

  List<Widget> pages = [Homepage(), ClientListScreen(), ChatList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: Colors.black,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Projects',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Project'),
        ],
      ),
    );
  }
}
