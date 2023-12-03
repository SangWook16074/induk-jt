import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class Com {
  String title;
  String content;
  String author;
  String time;

  Com(this.title, this.author, this.content, this.time);
}

class NoticeUpdatePage extends StatefulWidget {
  final String docID;
  final String title;
  final String content;
  const NoticeUpdatePage(this.docID, this.title, this.content, {Key? key})
      : super(key: key);

  @override
  State<NoticeUpdatePage> createState() => _NoticeUpdatePageState();
}

class _NoticeUpdatePageState extends State<NoticeUpdatePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  void _updateContent(String docID, String title, String content) {
    FirebaseFirestore.instance
        .collection('notice')
        .doc(docID)
        .update({"title": title, "content": content});
    _titleController.text = '';
    _contentController.text = '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "공지 수정",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (_titleController.text.isEmpty) {
                  toastMessage('제목을 입력하세요');
                  return;
                }
                if (_contentController.text.isEmpty) {
                  toastMessage('내용을 입력하세요');
                  return;
                }
                //수정하기
                _updateContent(widget.docID, _titleController.text,
                    _contentController.text);
                toastMessage('수정 완료!');

                Navigator.pop(context);
              },
              icon: Icon(Icons.check)),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close))
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
                      controller: _titleController,
                      onChanged: (text) {},
                      decoration: const InputDecoration(
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
                      controller: _contentController,
                      onChanged: (text) {},
                      decoration: const InputDecoration(
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
