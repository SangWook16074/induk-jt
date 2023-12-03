import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class Write {
  String title;
  String content;
  String price;
  String time;

  Write(
    this.title,
    this.content,
    this.price,
    this.time,
  );
}

class MarkerAddPage extends StatefulWidget {
  final String userNumber;
  MarkerAddPage({Key? key, required this.userNumber}) : super(key: key);

  @override
  State<MarkerAddPage> createState() => _MarkerAddPageState();
}

class _MarkerAddPageState extends State<MarkerAddPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  File? image;
  var _now;
  final title = TextEditingController(); // 제목
  final price = TextEditingController();
  final content = TextEditingController(); // 글

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

  void _createItemDialog(Write market) {
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
                  children: const [Text('상품을 등록하시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _addMarketItem(market);
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
                  children: const [Text('상품을 등록하시겠습니까?')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        _addMarketItem(market);
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

  void _addMarketItem(Write market) async {
    if (image != null) {
      String? token = await messaging.getToken();
      final ref = FirebaseStorage.instance
          .ref()
          .child('market')
          .child("${market.title}.jpg");
      final uploadTask = ref.putFile(image!);
      await uploadTask.whenComplete(() => null);

      final getUrl = await ref.getDownloadURL();
      FirebaseFirestore.instance.collection('market').add({
        'server': widget.userNumber,
        'title': market.title,
        'content': market.content,
        'number': widget.userNumber,
        'price': market.price,
        'time': market.time,
        'url': getUrl,
        'hateUsers': [],
        'serverToken': token,
      });

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "상품등록",
            style: GoogleFonts.doHyeon(
              textStyle: mainStyle,
            ),
          ),
          iconTheme: IconThemeData.fallback(),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  if (title.text.isEmpty) {
                    toastMessage('제목을 입력하세요');
                    return;
                  }
                  if (content.text.isEmpty) {
                    toastMessage('내용을 입력하세요');
                    return;
                  }
                  if (price.text.isEmpty) {
                    toastMessage('가격을 입력하세요');
                    return;
                  }
                  if (image == null) {
                    toastMessage('상품 사진을 업로드하세요');
                  }
                  try {
                    setState(() {
                      _now = DateFormat('yyyy-MM-dd - HH:mm:ss')
                          .format(DateTime.now());
                    });
                    _createItemDialog(
                      Write(title.text, content.text, price.text,
                          _now.toString()),
                    );
                  } catch (e) {
                    toastMessage("잠시 후에 다시 시도해주세요!");
                  }
                },
                icon: Icon(Icons.check))
          ],
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: title,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: "상품 이름을 입력해주세요.",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: price,
                  onChanged: (value) {
                    setState(() {});
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "판매가격을 입력해주세요.",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  maxLines: 10,
                  controller: content,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: '상품 상태 등을 적어주세요.',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    height: MediaQuery.of(context).size.width - 10,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: (image != null)
                        ? Image.file(
                            image!,
                            fit: BoxFit.fill,
                          )
                        : Stack(
                            children: [
                              Container(
                                color: Colors.grey,
                                child: Center(
                                    child: Text(
                                  '상품 사진 등록',
                                )),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.white,
                                      ),
                                      onPressed: pickImage,
                                    ),
                                  )),
                            ],
                          )),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
