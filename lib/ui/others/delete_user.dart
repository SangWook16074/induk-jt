import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../loginPage/login_page.dart';

class UserDelete extends StatefulWidget {
  final String userNumber;
  const UserDelete({Key? key, required this.userNumber}) : super(key: key);

  @override
  State<UserDelete> createState() => _UserDeleteState();
}

class _UserDeleteState extends State<UserDelete> {
  final _userNumber = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        (Platform.isAndroid)
            ? MaterialPageRoute(builder: (context) => LoginPage())
            : CupertinoPageRoute(builder: (context) => LoginPage()),
        (route) => false);
  }

  void deleteUserFromFirebase(BuildContext context, String docId) async {
    try {
      User? user = _auth.currentUser;
      user!.delete();
      CollectionReference users =
          FirebaseFirestore.instance.collection('UserInfo');
      users.doc(docId).delete();
    } catch (e) {
      toastMessage('다시 로그인 후 이용해주세요');
    }

    await _signOut();
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
                    "회원 탈퇴",
                    style: GoogleFonts.doHyeon(
                      textStyle: mainStyle,
                    ),
                  ),
                  Text("작성한 글은 커뮤니티에 그대로 보존됩니다.",
                      style: TextStyle(fontSize: 15, color: Colors.black)),
                  SizedBox(
                    height: 30,
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
                                      toastMessage('학번을 입력하세요.');
                                      return;
                                    }

                                    if (_userNumber.text != widget.userNumber) {
                                      toastMessage('학번이 잘못입력되었습니다.');
                                      return;
                                    }
                                    deleteUserFromFirebase(
                                        context, _userNumber.text);
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
                                      toastMessage('학번을 입력하세요.');
                                      return;
                                    }

                                    if (_userNumber.text != widget.userNumber) {
                                      toastMessage('학번이 잘못입력되었습니다.');
                                      return;
                                    }
                                    deleteUserFromFirebase(
                                        context, _userNumber.text);
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
