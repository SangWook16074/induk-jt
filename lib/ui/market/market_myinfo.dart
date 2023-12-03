import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/market/market_item_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MarketMyInfoPage extends StatefulWidget {
  final String userNumber;
  const MarketMyInfoPage({Key? key, required this.userNumber})
      : super(key: key);

  @override
  State<MarketMyInfoPage> createState() => _MarketMyInfoPageState();
}

class _MarketMyInfoPageState extends State<MarketMyInfoPage> {
  void _createUpdateItemDialog() {
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
                  children: const [Text('상품을 수정하시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                        //   return
                        // }));
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
                  children: const [Text('상품을 수정하시겠습니까?')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
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

  void _createDeleteItemDialog() {
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
                  children: const [Text('상품을 삭제하시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
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
                  children: const [Text('상품을 삭제하시겠습니까?')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('market')
            .where('server', isEqualTo: widget.userNumber)
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
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var id = snapshot.data!.docs[index].id.toString();
              var title = snapshot.data!.docs[index]['title'].toString();
              return _buildMyItemList(id, title);
            },
          );
        });
  }

  Widget _buildNonItem() {
    return Center(
      child: Container(
        child: Text(
          '등록된 상품이 없습니다.',
        ),
      ),
    );
  }

  Widget _buildMyItemList(String id, String title) {
    return Container(
      color: Colors.white,
      child: Slidable(
        endActionPane: ActionPane(motion: DrawerMotion(), children: [
          SlidableAction(
            onPressed: ((context) {
              _createUpdateItemDialog();
            }),
            label: '수정',
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[300]!,
          ),
          SlidableAction(
            onPressed: ((context) {
              _createDeleteItemDialog();
            }),
            label: '삭제',
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
          ),
        ]),
        child: ListTile(
          title: Text(title),
          onTap: () {
            Navigator.of(context).push((Platform.isAndroid)
                ? MaterialPageRoute(builder: (context) {
                    return MyItemView(
                      id: id,
                    );
                  })
                : CupertinoPageRoute(builder: (context) {
                    return MyItemView(
                      id: id,
                    );
                  }));
          },
        ),
      ),
    );
  }
}
