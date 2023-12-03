import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../main.dart';
import '../View_pages/com_view.dart';

class Com {
  String title;
  String content;
  String author;
  String time;

  Com(this.title, this.author, this.content, this.time);
}

class ComManagePage extends StatefulWidget {
  const ComManagePage({Key? key}) : super(key: key);

  @override
  State<ComManagePage> createState() => _ComManagePageState();
}

class _ComManagePageState extends State<ComManagePage> {
  void _deleteItemDialog(DocumentSnapshot doc) {
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
                  children: const [Text('정말로 삭제하시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _deleteItem(doc);
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
                  children: const [Text('정말로 삭제하시겠습니까?')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        _deleteItem(doc);
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

  void _deleteItem(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('com').doc(doc.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "익명게시판 관리",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('com')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Container(
                      child: const CircularProgressIndicator.adaptive()));
            }
            final documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return _buildNonEvent();
            } else {
              return ListView(
                shrinkWrap: true,
                children:
                    documents.map((doc) => _buildEventWidget(doc)).toList(),
              );
            }
          }),
    );
  }

  Widget _buildEventWidget(DocumentSnapshot doc) {
    final event = Com(doc['title'], doc['author'], doc['content'], doc['time']);
    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(motion: DrawerMotion(), children: [
            SlidableAction(
              onPressed: ((context) {
                _deleteItemDialog(doc);
              }),
              label: '삭제',
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
          ]),
          child: ListTile(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            onTap: () {
              Navigator.push(
                  context,
                  (Platform.isAndroid)
                      ? MaterialPageRoute(
                          builder: ((context) => ComViewPage(
                                title: event.title,
                                content: event.content,
                                author: '익명',
                                time: event.time,
                              )))
                      : CupertinoPageRoute(
                          builder: ((context) => ComViewPage(
                                title: event.title,
                                content: event.content,
                                author: '익명',
                                time: event.time,
                              ))));
            },
            title: Text(
              event.title,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "익명",
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildNonEvent() {
    return Center(
      child: Container(
        child: const Center(
          child: Text(
            '등록한 글이 없습니다.',
            style: TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
