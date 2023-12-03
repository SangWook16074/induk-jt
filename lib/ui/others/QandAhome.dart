import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:flutter_main_page/ui/others/QandA.dart';
import 'package:google_fonts/google_fonts.dart';

import '../View_pages/qna_view.dart';

class QuestionHome extends StatefulWidget {
  final String userNumber;
  const QuestionHome({Key? key, required this.userNumber}) : super(key: key);

  @override
  State<QuestionHome> createState() => _QuestionHomeState();
}

class _QuestionHomeState extends State<QuestionHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text("질문작성"),
        onPressed: () {
          Navigator.push(
              context,
              (Platform.isAndroid)
                  ? MaterialPageRoute(builder: ((context) {
                      return QuestionAddPage(userNumber: widget.userNumber);
                    }))
                  : CupertinoPageRoute(builder: ((context) {
                      return QuestionAddPage(userNumber: widget.userNumber);
                    })));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text(
          "Q / A",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
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
                .where('author', isEqualTo: widget.userNumber)
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

                        if (snapshot.hasData) {
                          return _buildItemWidget(
                              context,
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

  Widget _buildItemWidget(BuildContext context, String title, String content,
      String author, String time, String answer, String answerTime) {
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
                            builder: (context) => AnswerViewPage(
                                  answer: answer,
                                  answerTime: answerTime,
                                ))
                        : CupertinoPageRoute(
                            builder: (context) => AnswerViewPage(
                                  answer: answer,
                                  answerTime: answerTime,
                                )))
                : toastMessage('답변이 등록되지 않았습니다');
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
              ? Icon(Icons.mark_email_read, color: Colors.red)
              : Icon(
                  Icons.mark_email_unread,
                ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}
