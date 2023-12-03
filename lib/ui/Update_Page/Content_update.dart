import 'package:cached_network_image/cached_network_image.dart';
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

class ContentUpdatePage extends StatefulWidget {
  final String docID;
  final String title;
  final String content;
  final String? url;
  const ContentUpdatePage(
      {Key? key,
      required this.docID,
      required this.title,
      required this.content,
      required this.url})
      : super(key: key);

  @override
  State<ContentUpdatePage> createState() => _ContentUpdatePageState();
}

class _ContentUpdatePageState extends State<ContentUpdatePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  void _updateContent(String docID, String title, String content) {
    FirebaseFirestore.instance
        .collection('com')
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
          "수정하기",
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
                    Text('사진은 수정이 불가능합니다. 사진 수정을 하려면, 글을 지웠다가 다시 작성하셔야합니다.'),
                    SizedBox(
                      height: 5,
                    ),
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
                    (widget.url != null)
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  width: 70,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.url!,
                                    fit: BoxFit.fitWidth,
                                    placeholder: (context, url) => Container(
                                      color: Colors.black,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                )))
                        : Container(),
                    SizedBox(
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
