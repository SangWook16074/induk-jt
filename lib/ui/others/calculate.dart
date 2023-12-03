import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({Key? key}) : super(key: key);

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _GroupControllers {
  TextEditingController subject = TextEditingController();
  TextEditingController point = TextEditingController();
  TextEditingController getPoint = TextEditingController();
  void dispose() {
    subject.dispose();
    point.dispose();
    getPoint.dispose();
  }
}

class _CalculatePageState extends State<CalculatePage> {
  double resultGrade = 0;
  double resultPoint = 0;
  var _inputField = [];

  List<_GroupControllers> _groupControllers = [];

  @override
  void dispose() {
    for (final controller in _groupControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  var idx = 0;

  _refresh() {
    setState(() {
      resultGrade = 0;
      resultPoint = 0;
      _groupControllers.clear();
      _inputField.clear();
    });
  }

  _addInputField(context) {
    final group = _GroupControllers();
    final inputField =
        _generateInputField(group.subject, group.point, group.getPoint);

    setState(() {
      _groupControllers.add(group);
      _inputField.add(inputField);
    });
  }

  _generateInputField(subject, point, getPoint) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: subject,
              decoration: InputDecoration(
                hintText: "과목",
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: TextField(
              maxLength: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[2-4]'))
              ],
              controller: point,
              onChanged: (point) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "학점",
                counterText: "",
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: TextField(
              maxLength: 3,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]'))
              ],
              controller: getPoint,
              onChanged: (getPit) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "받은 점수",
                counterText: "",
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData.fallback(),
          actions: [
            IconButton(
              onPressed: () {
                _refresh();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
          backgroundColor: Colors.white,
          title: Text(
            "학점계산기",
            style: GoogleFonts.doHyeon(
              textStyle: mainStyle,
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildResult(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                          "Pass/Fail 교과목은 성적 산출에서 제외됩니다. 따라서 학점계산기에 기재하면 잘못된 성적이 산출됩니다.")),
                ),
                _buildCalculate(),
                _buildBottons(),
              ],
            )));
  }

  _calculate() {
    double resultP = 0;
    double resultG = 0;
    var sumP = 0;
    double sumG = 0;
    var div = 0;
    for (var i = 0; i < _inputField.length; i++) {
      if (int.parse(_groupControllers[i].getPoint.text) > 100) {
        toastMessage('정확한 점수를 입력하세요');
        return;
      }
      sumP += int.parse(_groupControllers[i].getPoint.text) *
          int.parse(_groupControllers[i].point.text);

      sumG += _invert(int.parse(_groupControllers[i].getPoint.text)) *
          int.parse(_groupControllers[i].point.text);

      div += int.parse(_groupControllers[i].point.text);
    }
    resultP = (sumP / div).toDouble();
    resultG = (sumG / div).toDouble();
    resultPoint = resultP;
    resultGrade = resultG;
  }

  _invert(int num) {
    if (num >= 95 && num <= 100) {
      return 4.5;
    } else if (num >= 90 && num < 95) {
      return 4.0;
    } else if (num >= 85 && num < 90) {
      return 3.5;
    } else if (num >= 80 && num < 85) {
      return 3.0;
    } else if (num >= 75 && num < 80) {
      return 2.5;
    } else if (num >= 70 && num < 75) {
      return 2.0;
    } else if (num >= 65 && num < 70) {
      return 1.5;
    } else if (num >= 60 && num < 65) {
      return 1.0;
    } else {
      return 0.0;
    }
  }

  Widget _buildCalculate() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _inputField.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    child: _inputField.elementAt(index),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _inputField.removeAt(index);
                        _groupControllers.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.remove_circle,
                        color: Colors.black38, size: 35)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResult() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        color: Colors.black12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "평점 : ${resultGrade.toStringAsFixed(4)}",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              "백분위 : ${resultPoint.toStringAsFixed(4)}",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: (Platform.isAndroid)
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 50,
                  width: 130,
                  child: ElevatedButton(
                      onPressed: () {
                        _addInputField(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text("과목추가"),
                        ],
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 130,
                  child: ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            _calculate();
                          });
                        } catch (e) {
                          toastMessage("제대로 입력했나요?");
                        }
                      },
                      child: Text("계산하기")),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 50,
                  width: 130,
                  child: CupertinoButton.filled(
                      padding: EdgeInsets.all(0.0),
                      minSize: 0.0,
                      onPressed: () {
                        _addInputField(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add),
                          Text("과목추가"),
                        ],
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 130,
                  child: CupertinoButton.filled(
                      padding: EdgeInsets.all(0.0),
                      minSize: 0.0,
                      onPressed: () async {
                        try {
                          setState(() {
                            _calculate();
                          });
                        } catch (e) {
                          toastMessage("제대로 입력했나요?");
                        }
                      },
                      child: Text("계산하기")),
                ),
              ],
            ),
    );
  }
}
