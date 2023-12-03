import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class AnswerViewPage extends StatefulWidget {
  final String answer;
  final String answerTime;
  const AnswerViewPage(
      {Key? key, required this.answer, required this.answerTime})
      : super(key: key);

  @override
  State<AnswerViewPage> createState() => _AnswerViewPageState();
}

class _AnswerViewPageState extends State<AnswerViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Q / A",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              child: Text(
                widget.answer,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Text(
                widget.answerTime,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
