import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:intl/intl.dart';

class QuestionManagePage extends StatefulWidget {
  const QuestionManagePage({Key? key}) : super(key: key);

  @override
  State<QuestionManagePage> createState() => _QuestionManagePageState();
}

class _QuestionManagePageState extends State<QuestionManagePage> {
  void _deleteItemDialog(String docID) {
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
                        _deleteItem(docID);
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
                        _deleteItem(docID);
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

  void _deleteItem(String docID) {
    FirebaseFirestore.instance.collection('QnA').doc(docID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Q / A',
          style:
              TextStyle(fontFamily: 'hoon', color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        iconTheme: IconThemeData.fallback(),
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildItem() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('QnA')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                        var docID = snapshot.data!.docs[index].id.toString();
                        print(docID);

                        if (snapshot.hasData) {
                          return _buildItemWidget(
                              context,
                              docID,
                              data['title'],
                              data['content'],
                              data['author'],
                              data['time'],
                              data['answer'] ?? '',
                              data['answerTime'] ?? '');
                        }

                        return Container();
                      });
            }),
      ),
    );
  }

  Widget _buildItemWidget(
      BuildContext context,
      String docID,
      String title,
      String content,
      String author,
      String time,
      String answer,
      String answerTime) {
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          onTap: () {
            (answer != '' || answerTime != '')
                ? Navigator.push(
                    context,
                    (Platform.isAndroid)
                        ? MaterialPageRoute(
                            builder: (context) => QuestionViewPage(
                                  docID: docID,
                                  userNumber: author,
                                  title: title,
                                  content: content,
                                  time: time,
                                  answer: answer,
                                  answerTime: answerTime,
                                ))
                        : CupertinoPageRoute(
                            builder: (context) => QuestionViewPage(
                                  docID: docID,
                                  userNumber: author,
                                  title: title,
                                  content: content,
                                  time: time,
                                  answer: answer,
                                  answerTime: answerTime,
                                )))
                : Navigator.push(
                    context,
                    (Platform.isAndroid)
                        ? MaterialPageRoute(
                            builder: (context) => AnswerPage(
                                  docID: docID,
                                  userNumber: author,
                                  title: title,
                                  content: content,
                                  time: time,
                                ))
                        : CupertinoPageRoute(
                            builder: (context) => AnswerPage(
                                  docID: docID,
                                  userNumber: author,
                                  title: title,
                                  content: content,
                                  time: time,
                                )));
          },
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            time,
            style: const TextStyle(fontSize: 10),
          ),
          trailing: (answer != '')
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.green),
                    IconButton(
                        onPressed: () {
                          _deleteItemDialog(docID);
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ))
                  ],
                )
              : Icon(
                  Icons.edit,
                  color: Colors.red,
                ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}

class QuestionViewPage extends StatelessWidget {
  final String docID;
  final String userNumber;
  final String title;
  final String content;
  final String time;
  final String answer;
  final String answerTime;

  const QuestionViewPage({
    Key? key,
    required this.userNumber,
    required this.title,
    required this.content,
    required this.time,
    required this.answer,
    required this.answerTime,
    required this.docID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'From. ${this.userNumber}',
          style:
              TextStyle(fontFamily: 'hoon', color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        iconTheme: IconThemeData.fallback(),
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                this.title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
              subtitle: Text(
                this.time,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Text(
                this.content,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Divider(),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Text(
                    "To. ${this.userNumber}",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          (Platform.isAndroid)
                              ? MaterialPageRoute(builder: (context) {
                                  return AnswerUpdatePage(
                                      userNumber: this.userNumber,
                                      title: this.title,
                                      content: this.content,
                                      time: this.time,
                                      answer: this.answer,
                                      docID: this.docID);
                                })
                              : CupertinoPageRoute(builder: (context) {
                                  return AnswerUpdatePage(
                                      userNumber: this.userNumber,
                                      title: this.title,
                                      content: this.content,
                                      time: this.time,
                                      answer: this.answer,
                                      docID: this.docID);
                                }));
                    },
                    child: Text("수정")),
              ],
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Text(
                this.answer,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Text(
                this.answerTime,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerPage extends StatefulWidget {
  final String docID;
  final String userNumber;
  final String title;
  final String content;
  final String time;

  const AnswerPage({
    Key? key,
    required this.userNumber,
    required this.title,
    required this.content,
    required this.time,
    required this.docID,
  }) : super(key: key);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  var _now;
  final _answer = TextEditingController();

  void _addAnswer(String docID, String answer) {
    FirebaseFirestore.instance.collection('QnA').doc(docID).update({
      'answer': answer,
      'answerTime': _now,
    });

    _answer.text = '';
  }

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (_answer.text == '') {
                  toastMessage('답변 내용을 입력하세요');
                  return;
                }

                _addAnswer(widget.docID, _answer.text);
                Navigator.of(context).pop();
                toastMessage("답변 완료!");
              },
              icon: Icon(Icons.check))
        ],
        title: Text(
          'From. ${widget.userNumber}',
          style:
              TextStyle(fontFamily: 'hoon', color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        iconTheme: IconThemeData.fallback(),
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                widget.title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: Text(
                widget.time,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Text(
                widget.content,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Divider(),
            TextField(
              minLines: 15,
              maxLines: 100,
              controller: _answer,
              onChanged: (text) {
                setState(() {});
              },
              decoration: const InputDecoration(
                  hintText: "답변을 입력하세요.",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  filled: true,
                  fillColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerUpdatePage extends StatefulWidget {
  final String docID;
  final String userNumber;
  final String title;
  final String content;
  final String answer;
  final String time;

  const AnswerUpdatePage({
    Key? key,
    required this.userNumber,
    required this.title,
    required this.content,
    required this.time,
    required this.docID,
    required this.answer,
  }) : super(key: key);

  @override
  State<AnswerUpdatePage> createState() => _AnswerUpdatePageState();
}

class _AnswerUpdatePageState extends State<AnswerUpdatePage> {
  var _now;
  late TextEditingController _answer;

  void _addAnswer(String docID, String answer, String time) {
    FirebaseFirestore.instance.collection('QnA').doc(docID).update({
      'answer': answer,
      'answerTime': time,
    });

    _answer.text = '';
  }

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _answer = TextEditingController(text: widget.answer);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (_answer.text == '') {
                  toastMessage('답변 내용을 입력하세요');
                  return;
                }
                setState(() {
                  _now = DateFormat('yyyy-MM-dd - HH:mm:ss')
                      .format(DateTime.now());
                });
                _addAnswer(widget.docID, _answer.text, _now);
                Navigator.of(context).pop();
                toastMessage("수정 완료!");
              },
              icon: Icon(Icons.check))
        ],
        title: Text(
          'From. ${widget.userNumber}',
          style:
              TextStyle(fontFamily: 'hoon', color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        iconTheme: IconThemeData.fallback(),
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ListTile(
              title: Text(
                widget.title,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: Text(
                widget.time,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Divider(),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Text(
                widget.content,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Divider(),
            TextField(
              minLines: 15,
              maxLines: 100,
              controller: _answer,
              onChanged: (text) {},
              decoration: const InputDecoration(
                  hintText: "답변을 입력하세요.",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  filled: true,
                  fillColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
