import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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

class WriteComPage extends StatefulWidget {
  final String userNumber;
  const WriteComPage({Key? key, required this.userNumber}) : super(key: key);

  @override
  State<WriteComPage> createState() => _WriteComPageState();
}

class _WriteComPageState extends State<WriteComPage> {
  File? image;
  var _now;
  final _title = TextEditingController();
  final _content = TextEditingController();

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
                    Text('글을 등록하시겠습니까?\n등록된 글은 내정보 페이지에서 관리할 수 있습니다.')
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _addNotice(event);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        toastMessage('작성완료!');
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
                    Text('글을 등록하시겠습니까?\n등록된 글은 내정보 페이지에서 관리할 수 있습니다.')
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        _addNotice(event);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        toastMessage('작성완료!');
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

  void _addNotice(Write com) async {
    if (image != null) {
      final ref =
          FirebaseStorage.instance.ref().child('com').child("${com.title}.jpg");
      final uploadTask = ref.putFile(image!);
      await uploadTask.whenComplete(() => null);

      final getUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('com').add({
        'author': '익명',
        'title': com.title,
        'content': com.content,
        'number': widget.userNumber,
        'time': com.time,
        'countLike': 0,
        'likedUsersList': [],
        'url': getUrl,
        'hateUsers': [],
      });

      return;
    }

    FirebaseFirestore.instance.collection('com').add({
      'author': '익명',
      'title': com.title,
      'content': com.content,
      'number': widget.userNumber,
      'time': com.time,
      'countLike': 0,
      'likedUsersList': [],
      'url': '',
      'hateUsers': [],
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
          "글쓰기",
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
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                        '작성된 글은 모두 익명으로 표시되며, 특수한 경우(비난, 비방, 명예훼손의 경우) 익명성이 보장되지 않습니다.')
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
