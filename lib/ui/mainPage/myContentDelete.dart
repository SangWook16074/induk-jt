import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/View_pages/com_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../Update_Page/Content_update.dart';

class Com {
  String title;
  String content;
  String author;
  String time;
  String? url;
  Com(this.title, this.author, this.content, this.time, this.url);
}

class MyContentManagePage extends StatefulWidget {
  final String user;
  MyContentManagePage(this.user, {Key? key}) : super(key: key);

  @override
  State<MyContentManagePage> createState() => _MyContentManagePageState();
}

class _MyContentManagePageState extends State<MyContentManagePage> {
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

  void _updateItemDialog(DocumentSnapshot doc, String docID, String title,
      String content, String? url) {
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
                  children: const [Text('수정하시겠습니까??')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ContentUpdatePage(
                                    docID: docID,
                                    title: title,
                                    content: content,
                                    url: (url! == '') ? null : url))));
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
                  children: const [Text('수정하시겠습니까??')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) => ContentUpdatePage(
                                    docID: docID,
                                    title: title,
                                    content: content,
                                    url: (url! == '') ? null : url))));
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

  void _deleteItem(DocumentSnapshot doc) async {
    FirebaseFirestore.instance.collection('com').doc(doc.id).delete();
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance.collection('com/${doc.id}/chat');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "내가 쓴 글",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('com')
              .where('number', isEqualTo: widget.user)
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
    final com = Com(
        doc['title'], doc['author'], doc['content'], doc['time'], doc['url']);
    return Column(
      children: [
        Builder(builder: (context) {
          return Slidable(
            endActionPane: ActionPane(motion: DrawerMotion(), children: [
              SlidableAction(
                onPressed: (context) {
                  _deleteItemDialog(doc);
                },
                icon: Icons.delete,
                label: '삭제',
                foregroundColor: Colors.red,
              ),
              SlidableAction(
                onPressed: (context) {
                  _updateItemDialog(doc, doc.id, com.title, com.content,
                      (com.url == '') ? null : com.url);
                },
                icon: Icons.update,
                label: '수정',
                foregroundColor: Colors.blue,
              ),
            ]),
            child: ListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              onTap: () {
                Navigator.push(
                    context,
                    (Platform.isAndroid)
                        ? MaterialPageRoute(
                            builder: (context) => ComViewPage(
                                  title: com.title,
                                  content: com.content,
                                  author: com.author,
                                  time: com.time,
                                  id: doc.id,
                                  user: widget.user,
                                  url: (com.url == "") ? null : com.url,
                                ))
                        : CupertinoPageRoute(
                            builder: (context) => ComViewPage(
                                  title: com.title,
                                  content: com.content,
                                  author: com.author,
                                  time: com.time,
                                  id: doc.id,
                                  user: widget.user,
                                  url: (com.url == "") ? null : com.url,
                                )));
              },
              title: Text(
                com.title,
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
          );
        }),
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
