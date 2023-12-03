import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/market/market_chat_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MarketChatPage extends StatefulWidget {
  final String userNumber;
  const MarketChatPage({Key? key, required this.userNumber}) : super(key: key);

  @override
  State<MarketChatPage> createState() => _MarketChatPageState();
}

class _MarketChatPageState extends State<MarketChatPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .where('listener', arrayContains: widget.userNumber)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return _buildNonItem();
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  var id = snapshot.data!.docs[index].id;

                  return _buildChatItem(
                    id,
                    data['title'],
                    data['productName'],
                    data['listener'],
                  );
                });
          }
          return _buildNonItem();
        });
  }

  Widget _buildChatItem(
      String id, String title, String productName, List listener) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Slidable(
            endActionPane: ActionPane(motion: DrawerMotion(), children: [
              SlidableAction(
                onPressed: ((context) {
                  _createItemDialog(id);
                }),
                label: '나가기',
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
            ]),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push((Platform.isAndroid)
                    ? MaterialPageRoute(builder: (context) {
                        return ChatViewPage(
                          chatID: id,
                          userNumber: widget.userNumber,
                        );
                      })
                    : CupertinoPageRoute(builder: (context) {
                        return ChatViewPage(
                          chatID: id,
                          userNumber: widget.userNumber,
                        );
                      }));
              },
              title: Text(
                productName,
              ),
              subtitle: Text(title),
              leading: Icon(Icons.message_outlined),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNonItem() {
    return Center(
      child: Container(
        child: Text(
          '등록된 채팅이 없습니다.',
        ),
      ),
    );
  }

  Future<void> quitChatRoom(String id) async {
    var list =
        await FirebaseFirestore.instance.collection('chat').doc(id).get();
    await FirebaseFirestore.instance.collection('chat').doc(id).set(
        {'listener': userQuit(list['listener'], widget.userNumber)},
        SetOptions(merge: true));
  }

  userQuit(List usersList, String userNumber) {
    usersList.remove(userNumber);

    return usersList;
  }

  void _createItemDialog(String id) {
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
                  children: const [Text('대화방을 나가시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        quitChatRoom(id);
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
                  children: const [Text('대화방을 나가시겠습니까?')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        quitChatRoom(id);
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
}
