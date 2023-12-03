import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Write {
  String title;
  String content;
  String time;

  Write(
    this.title,
    this.content,
    this.time,
  );
}

class WriteEventPage extends StatefulWidget {
  const WriteEventPage({Key? key}) : super(key: key);

  @override
  State<WriteEventPage> createState() => _WriteEventPageState();
}

class _WriteEventPageState extends State<WriteEventPage> {
  File? image;
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

  void _createItemDialog(Write event) {
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
                  children: const [
                    Text('이벤트를 등록하시겠습니까? \n등록된 이벤트는 내정보 페이지에서 관리할 수 있습니다.')
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        callOnFcmApiSendPushNotifications(
                            title: '새 이벤트가 등록되었습니다.',
                            body: '[이벤트] ${event.title}');
                        _addNotice(event);
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
                  children: const [
                    Text('이벤트를 등록하시겠습니까? \n등록된 이벤트는 내정보 페이지에서 관리할 수 있습니다.')
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        callOnFcmApiSendPushNotifications(
                            title: '새 이벤트가 등록되었습니다.',
                            body: '[이벤트] ${event.title}');
                        _addNotice(event);
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

  void _addNotice(Write event) async {
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('event')
          .child("${event.title}.jpg");
      final uploadTask = ref.putFile(image!);
      await uploadTask.whenComplete(() => null);

      final getUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('event').add({
        'title': event.title,
        'content': event.content,
        'author': '학생회',
        'time': event.time,
        'countLike': 0,
        'likedUsersList': [],
        'url': getUrl
      });

      return;
    }

    FirebaseFirestore.instance.collection('event').add({
      'title': event.title,
      'content': event.content,
      'author': '학생회',
      'time': event.time,
      'countLike': 0,
      'likedUsersList': [],
      'url': ''
    });
    _title.text = '';
    _content.text = '';
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
      });
    } catch (e) {
      toastMessage('에러! 잠시뒤에 다시 시도해주세요');
    }
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
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "이벤트 작성",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                pickImage();
              },
              icon: Icon(Icons.image_outlined)),
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
                try {
                  setState(() {
                    _now = DateFormat('yyyy-MM-dd - HH:mm:ss')
                        .format(DateTime.now());
                  });
                  _createItemDialog(
                    Write(_title.text, _content.text, _now.toString()),
                  );
                } catch (e) {
                  toastMessage("잠시 후에 다시 시도해주세요!");
                }
              },
              icon: Icon(Icons.check)),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          shrinkWrap: true,
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
                    (image != null)
                        ? Container(
                            child: Image.file(
                              image!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(),
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
