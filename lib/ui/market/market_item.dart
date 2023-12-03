import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/market/market_chat_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';
import '../View_pages/zoom_image.dart';

// ignore: must_be_immutable
class MarketItemPage extends StatelessWidget {
  final String userNumber;
  final String id;
  final String server;
  final String title;
  final String content;
  final String price;
  final String time;
  final String url;
  final String serverToken;
  MarketItemPage({
    Key? key,
    required this.id,
    required this.userNumber,
    required this.server,
    required this.title,
    required this.content,
    required this.price,
    required this.time,
    required this.url,
    required this.serverToken,
  }) : super(key: key);

  String chatID = Uuid().v1();

  Future _checkAlreadyQuest(BuildContext context) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('chat')
          .where('listner', arrayContains: this.userNumber)
          .where('productID', isEqualTo: this.id)
          .get();

      if (data.size != 0) {
        toastMessage('이미 문의한 상품입니다');
        return;
      }

      _makeChatRoom(context);
    } on Exception {
      toastMessage('잠시후에 다시 시도해주세요');
    }
  }

  void _makeChatRoom(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? myToken = await messaging.getToken();
    var db = FirebaseFirestore.instance.collection('chat').doc(chatID);
    db.set({
      'listener': [
        this.server,
        this.userNumber,
      ],
      'token': {this.server: myToken, this.userNumber: this.serverToken},
      'title': '새롭게 생긴 채팅',
      'time': Timestamp.now(),
      'productID': this.id,
      'productName': this.title,
    });
    db.collection('messages').add({});

    await Navigator.of(context).pushReplacement((Platform.isAndroid)
        ? MaterialPageRoute(builder: (context) {
            return ChatViewPage(
              chatID: chatID,
              userNumber: this.userNumber,
            );
          })
        : CupertinoPageRoute(builder: (context) {
            return ChatViewPage(
              chatID: chatID,
              userNumber: this.userNumber,
            );
          }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "전공서 중고마켓",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        iconTheme: IconThemeData.fallback(),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (this.server == this.userNumber) {
            toastMessage('본인이 등록한 상품입니다');
            return;
          }
          _checkAlreadyQuest(context);
        },
        icon: Icon(Icons.chat),
        label: Text('문의하기'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push((Platform.isAndroid)
                        ? MaterialPageRoute(builder: (context) {
                            return ZoomImage(url: url);
                          })
                        : CupertinoPageRoute(builder: (context) {
                            return ZoomImage(url: url);
                          }));
                  },
                  child: Hero(
                      transitionOnUserGestures: true,
                      tag: url,
                      child: Container(
                          width: MediaQuery.of(context).size.width - 30,
                          height: MediaQuery.of(context).size.width - 30,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(24.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => Container(
                                    color: Colors.black,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ))))),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // ignore: sort_child_properties_last, prefer_const_constructors
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 25,
                      width: 0.3,
                      color: Colors.black,
                    ),
                    Container(
                      // ignore: sort_child_properties_last, prefer_const_constructors
                      child: Text(
                        '$price원',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 10,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      child: Text(time),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 10,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // ignore: sort_child_properties_last, prefer_const_constructors
                  child: Text(content),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
