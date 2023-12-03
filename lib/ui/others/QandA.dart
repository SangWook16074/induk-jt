import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class QuestionAddPage extends StatefulWidget {
  final String userNumber;
  const QuestionAddPage({Key? key, required this.userNumber}) : super(key: key);

  @override
  State<QuestionAddPage> createState() => _QuestionAddPageState();
}

class _QuestionAddPageState extends State<QuestionAddPage> {
  var _now;
  final _title = TextEditingController();
  final _content = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _addQuestion(String title, String content, String _now) {
    FirebaseFirestore.instance.collection('QnA').add({
      'title': title,
      'content': content,
      'author': widget.userNumber,
      'time': _now,
    });
    toastMessage("피드백을 작성해주셔서 감사합니다 !");
    _title.text = '';
    _content.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "Q / A",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                if (_title.text.isEmpty) {
                  toastMessage("제목을 입력하세요.");
                  return;
                }
                if (_content.text.isEmpty) {
                  toastMessage("내용을 입력하세요");
                }
                setState(() {
                  _now = DateFormat('yyyy-MM-dd - HH:mm:ss')
                      .format(DateTime.now());
                });

                _addQuestion(_title.text, _content.text, _now);
                Navigator.of(context).pop();
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
                    Text(
                        "질문이 있으시다면 질문을 작성해주세요!\n답변이 완료된 질문은 일정기간 후 삭제될 수 있습니다."),
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
