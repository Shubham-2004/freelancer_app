import 'package:flutter/material.dart';

class ClientFreelancerChatPage extends StatefulWidget {
  const ClientFreelancerChatPage({super.key});

  @override
  State<ClientFreelancerChatPage> createState() =>
      _ClientFreelancerChatPageState();
}

class _ClientFreelancerChatPageState extends State<ClientFreelancerChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade900, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text("Chat People", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
    );
  }
}
