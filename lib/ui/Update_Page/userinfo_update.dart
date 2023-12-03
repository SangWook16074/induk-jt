import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';

class UserInfoUpdate extends StatefulWidget {
  const UserInfoUpdate({Key? key}) : super(key: key);

  @override
  State<UserInfoUpdate> createState() => _UserInfoUpdateState();
}

class _UserInfoUpdateState extends State<UserInfoUpdate> {
  final _userNumber = TextEditingController();
  final _currentEmail = TextEditingController();
  final _newEmail = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future checkUserInfo(
      String userNumber, String currentEmail, String newEmail) async {
    DocumentSnapshot check = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(userNumber)
        .get();

    if (!check.exists) {
      toastMessage('존재하지 않는 학번입니다');
      return;
    }
    if (check['email'] != currentEmail) {
      toastMessage('이메일 주소가 일치하지 않습니다');
      return;
    }
    updateEmail(userNumber, newEmail);
  }

  Future updateEmail(String user, String newEmail) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }));
    try {
      await _auth.currentUser!.updateEmail(newEmail);
      await _auth.currentUser!.sendEmailVerification();
      FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(user)
          .update({'email': newEmail});
      toastMessage('이메일이 변경되었습니다');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      toastMessage('잠시 후에 다시 시도해주세요');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: Column(
                children: [
                  Text(
                    "이메일 재설정",
                    style: GoogleFonts.doHyeon(
                      textStyle: mainStyle,
                    ),
                  ),
                  Text(
                    "입력한 정보가 맞다면, 이메일이 재설정 됩니다.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "재설정된 이메일은 이메일 인증을 다시 해야합니다. 변경한 이메일로 인증을 완료 후 다시 로그인할 수 있습니다.",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _currentEmail,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: "현재 E-mail",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        suffixIcon: GestureDetector(
                          child: const Icon(
                            Icons.clear,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                          onTap: () => _currentEmail.clear(),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _newEmail,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: "변경할 E-mail",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        suffixIcon: GestureDetector(
                          child: const Icon(
                            Icons.clear,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                          onTap: () => _newEmail.clear(),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: _userNumber,
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: "학번",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        suffixIcon: GestureDetector(
                          child: const Icon(
                            Icons.clear,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                          onTap: () => _userNumber.clear(),
                        ),
                        filled: true,
                        fillColor: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (Platform.isAndroid)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 80,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_userNumber.text == '') {
                                      toastMessage('학번을 입력하세요');
                                      return;
                                    }
                                    if (_currentEmail.text == '') {
                                      toastMessage('이메일을 입력하세요');
                                      return;
                                    }
                                    if (_newEmail.text == '') {
                                      toastMessage('변경할 이메일을 입력하세요');
                                      return;
                                    }
                                    checkUserInfo(_userNumber.text,
                                        _currentEmail.text, _newEmail.text);
                                  },
                                  child: Text('확인')),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 80,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '취소',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 40,
                              child: CupertinoButton.filled(
                                  padding: EdgeInsets.all(0.0),
                                  minSize: 80.0,
                                  onPressed: () {
                                    if (_userNumber.text == '') {
                                      toastMessage('학번을 입력하세요');
                                      return;
                                    }
                                    if (_currentEmail.text == '') {
                                      toastMessage('이메일을 입력하세요');
                                      return;
                                    }
                                    if (_newEmail.text == '') {
                                      toastMessage('변경할 이메일을 입력하세요');
                                      return;
                                    }
                                    checkUserInfo(_userNumber.text,
                                        _currentEmail.text, _newEmail.text);
                                  },
                                  child: Text('확인')),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 40,
                              child: CupertinoButton(
                                padding: EdgeInsets.all(0.0),
                                minSize: 80.0,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  '취소',
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
