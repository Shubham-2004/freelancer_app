import 'package:flutter/material.dart';
import 'package:freelancer_app/chat_service/pages/chat_list.dart';
import 'package:freelancer_app/chat_service/pages/chat_screen.dart';
import 'package:freelancer_app/client_side/pages/client_freelancer_chat_page.dart';

import 'package:freelancer_app/client_side/pages/client_home_page.dart';
import 'package:freelancer_app/client_side/pages/clinet_projects.dart';

class ClientBottomNavigation extends StatefulWidget {
  const ClientBottomNavigation({Key? key}) : super(key: key);

  @override
  State<ClientBottomNavigation> createState() => _ClientBottomNavigationState();
}

class _ClientBottomNavigationState extends State<ClientBottomNavigation> {
  int currentIndex = 0;

  List<Widget> pages = [
    ClientHomePage(),
    ClinetProjects(),
    ChatList()
  ];
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
            icon: Icon(Icons.edit_document),
            label: 'Projects',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
