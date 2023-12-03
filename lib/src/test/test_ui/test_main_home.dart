import 'package:flutter/material.dart';
import 'package:flutter_main_page/src/constants/firebase_const.dart';

class TestHome extends StatelessWidget {
  const TestHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
          child: Text(
        '성공 !',
        style: TextStyle(fontSize: 40),
      )),
    );
  }
}
