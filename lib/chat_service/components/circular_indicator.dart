import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      backgroundColor: Colors.transparent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "Loading ...",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
