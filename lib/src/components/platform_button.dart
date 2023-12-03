import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformBackButton extends StatelessWidget {
  final void Function()? onPressed;

  const PlatformBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return (Platform.isAndroid)
        ? SizedBox(
            width: 200,
            child: ElevatedButton(
                //취소 버튼

                onPressed: onPressed,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.all(16.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back),
                    Text(
                      "이전",
                      style: TextStyle(fontSize: 15, letterSpacing: 4.0),
                    ),
                  ],
                )),
          )
        : SizedBox(
            width: 200,
            child: CupertinoButton(
                //취소 버튼

                onPressed: onPressed,
                color: Colors.blueGrey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios),
                    Text(
                      "이전",
                      style: TextStyle(fontSize: 15, letterSpacing: 4.0),
                    ),
                  ],
                )),
          );
  }
}
