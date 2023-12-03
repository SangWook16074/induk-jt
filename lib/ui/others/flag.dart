import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class FlagWrite {
  String title;
  String content;
  String time;

  FlagWrite(this.title, this.content, this.time);
}

class FlagPage extends StatefulWidget {
  final String user;
  final String targetTitle;
  final String targetTime;
  final String id;
  final List? hateUsers;
  const FlagPage(
      {Key? key,
      required this.user,
      required this.targetTime,
      required this.targetTitle,
      required this.id,
      required this.hateUsers})
      : super(key: key);

  @override
  State<FlagPage> createState() => _FlagPageState();
}

class _FlagPageState extends State<FlagPage> {
  var _now;
  final _title = TextEditingController();
  final _content = TextEditingController();
  void _createItemDialog(FlagWrite flag, String user) {
    (Platform.isAndroid)
        ? showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [Text('신고내용을 접수하시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _addNotice(
                            flag, user, widget.targetTitle, widget.targetTime);
                        _addhateUsers();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("확인")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("취소")),
                ],
              );
            })
        : showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [Text('신고내용을 접수하시겠습니까?')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        _addNotice(
                            flag, user, widget.targetTitle, widget.targetTime);
                        _addhateUsers();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("확인")),
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("취소")),
                ],
              );
            });
  }

  void _addNotice(
      FlagWrite flag, String user, String targetTitle, String targetTime) {
    FirebaseFirestore.instance.collection('flag').add({
      'title': flag.title,
      'content': flag.content,
      'author': user,
      'time': flag.time,
      'targetTitle': targetTitle,
      'targetTime': targetTime
    });
    toastMessage('신고가 등록되었습니다');
    _title.text = '';
    _content.text = '';
  }

  void _addhateUsers() {
    FirebaseFirestore.instance.collection('com').doc(widget.id).set({
      'hateUsers': userCheck(widget.hateUsers!, widget.user),
    }, SetOptions(merge: true));
  }

  userCheck(List usersList, String userNumber) {
    if (usersList.contains(userNumber)) {
      usersList.remove(userNumber);
    } else {
      usersList.add(userNumber);
    }
    return usersList;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "신고하기",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (_title.text.isEmpty) {
                  toastMessage('신고제목을 입력하세요');
                  return;
                }
                if (_content.text.isEmpty) {
                  toastMessage('신고내용을 입력하세요');
                  return;
                }
                setState(() {
                  _now = DateFormat('yyyy-MM-dd - HH:mm:ss')
                      .format(DateTime.now());
                });
                _createItemDialog(
                    FlagWrite(_title.text, _content.text, _now.toString()),
                    "정보통신공학과");
              },
              icon: Icon(Icons.check))
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: [
            Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    TextField(
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      minLines: 1,
                      maxLines: 10,
                      controller: _title,
                      onChanged: (text) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: "신고제목",
                          hintStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      minLines: 15,
                      maxLines: 100,
                      controller: _content,
                      onChanged: (text) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: "신고내용을 입력하세요",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
