import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const LoginButton({super.key, this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 355,
      child: (Platform.isAndroid)
          ? ElevatedButton(
              //로그인 버튼

              onPressed: onPressed,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.all(16.0),
              ),
              child: child)
          : CupertinoButton(
              //로그인 버튼

              onPressed: onPressed,
              color: Colors.blueGrey,
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                "로그인",
                style: TextStyle(
                    fontSize: 15, letterSpacing: 4.0, color: Colors.white),
              )),
    );
  }
}
