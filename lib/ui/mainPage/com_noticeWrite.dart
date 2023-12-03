// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class NoticeWrite {
  String title;
  String content;
  String time;

  NoticeWrite(this.title, this.content, this.time);
}

class WriteNotice extends StatefulWidget {
  WriteNotice({Key? key}) : super(key: key);

  @override
  State<WriteNotice> createState() => _WriteNoticeState();
}

class _WriteNoticeState extends State<WriteNotice> {
  var _now;
  final _title = TextEditingController();
  final _content = TextEditingController();

  Future<bool> callOnFcmApiSendPushNotifications(
      {required String title, required String body}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": "/topics/connectTopic",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "type": '0rder',
        "id": '28',
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAGD39BhQ:APA91bHJ2kDvwE9yttcSqmN674ZRazo7fUhPnS7TplSCnX5TAZIFqkTP4tD-Gw2wb71Ul5JMD-KScUl9oQ1eB2pMIRG1GwX7gyz7KxKZHbRWuc7D7qa86KxyI8FGo9oOPUju3MZxsZg4' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

  void _createItemDialog(NoticeWrite notice, String user) {
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
                  children: const [Text('공지를 등록하시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        callOnFcmApiSendPushNotifications(
                            title: '새 공지사항이 등록되었습니다.',
                            body: "[공지사항] ${notice.title}");

                        _addNotice(notice, user);
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
                  children: const [Text('공지를 등록하시겠습니까?')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        callOnFcmApiSendPushNotifications(
                            title: '새 공지사항이 등록되었습니다.',
                            body: "[공지사항] ${notice.title}");

                        _addNotice(notice, user);
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

  void _addNotice(NoticeWrite notice, String user) {
    FirebaseFirestore.instance.collection('notice').add({
      'title': notice.title,
      'content': notice.content,
      'author': user,
      'time': notice.time,
    });
    toastMessage('새 공지가 등록되었습니다');
    _title.text = '';
    _content.text = '';
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
          "공지작성",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (_title.text.isEmpty) {
                  toastMessage('제목을 입력하세요');
                  return;
                }
                if (_content.text.isEmpty) {
                  toastMessage('내용을 입력하세요');
                  return;
                }
                setState(() {
                  _now = DateFormat('yyyy-MM-dd - HH:mm:ss')
                      .format(DateTime.now());
                });
                _createItemDialog(
                    NoticeWrite(_title.text, _content.text, _now.toString()),
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
                          hintText: "제목",
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
                          hintText: "내용을 입력하세요",
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
