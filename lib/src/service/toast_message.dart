import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Message {
  static showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: '토스트 메시지',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.white,
        textColor: Colors.black);
  }
}
