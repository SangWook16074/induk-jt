import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/market/market_item.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

enum MenuItem { item1, item2 }

class MarketHomePage extends StatefulWidget {
  final String userNumber;
  const MarketHomePage({Key? key, required this.userNumber}) : super(key: key);

  @override
  State<MarketHomePage> createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> {
  void _createBlurItemDialog(String id, List hateUsers) {
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
                  children: const [Text('의견을 제출하시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _updateHateUsers(id, widget.userNumber, hateUsers);
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
                  children: const [Text('의견을 제출하시겠습니까?')],
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

  Future<void> _updateHateUsers(
      String id, String myNumber, List hateUsers) async {
    FirebaseFirestore.instance.collection('market').doc(id).set({
      'hateUsers': userCheck(hateUsers, widget.userNumber),
    }, SetOptions(merge: true));
  }

  userCheck(List usersList, String userNumber) {
    if (usersList.contains(userNumber)) {
      usersList.remove(userNumber);
    } else {
      usersList.add(userNumber);
    }
    return usersList;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('market')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (!snapshot.hasData) {
            return _buildNonItem();
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  var id = snapshot.data!.docs[index].id.toString();

                  return _buildMarketItem(
                      id,
                      data['server'],
                      data['title'],
                      data['price'],
                      data['time'],
                      data['content'],
                      data['url'],
                      data['hateUsers'],
                      data['serverToken']);
                });
          }
        });
  }

  Widget _buildMarketItem(
      String id,
      String server,
      String title,
      String price,
      String time,
      String content,
      String url,
      List hateUsers,
      String serverToken) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 10,
        height: MediaQuery.of(context).size.width * (1 / 3) + 15,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push((Platform.isAndroid)
                    ? MaterialPageRoute(builder: (context) {
                        return MarketItemPage(
                          id: id,
                          userNumber: widget.userNumber,
                          server: server,
                          title: title,
                          price: price,
                          time: time,
                          content: content,
                          url: url,
                          serverToken: serverToken,
                        );
                      })
                    : CupertinoPageRoute(builder: (context) {
                        return MarketItemPage(
                          userNumber: widget.userNumber,
                          server: server,
                          id: id,
                          title: title,
                          price: price,
                          time: time,
                          content: content,
                          url: url,
                          serverToken: serverToken,
                        );
                      }));
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                height: MediaQuery.of(context).size.width * (1 / 3) + 15,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 24.0,
                          offset: Offset(16, 16),
                          color: Color.fromARGB(255, 178, 176, 176))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * (1 / 3),
                          height: MediaQuery.of(context).size.width * (1 / 3),
                          child: CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              color: Colors.black,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.doHyeon(
                              textStyle: mainStyle,
                            ),
                          ),
                          Text(
                            '$price원',
                            style: GoogleFonts.doHyeon(
                              textStyle: mainStyle,
                            ),
                          ),
                          Text(time)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: (!hateUsers.contains(widget.userNumber))
                  ? Container(
                      width: MediaQuery.of(context).size.width - 10,
                      height: MediaQuery.of(context).size.width * (1 / 3) + 15,
                    )
                  : GestureDetector(
                      onTap: () {
                        toastMessage('숨긴 상품입니다');
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 10,
                          height:
                              MediaQuery.of(context).size.width * (1 / 3) + 15,
                          child: Stack(
                            children: [
                              BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 20,
                                    sigmaY: 20,
                                  ),
                                  child: Container()),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius:
                                          BorderRadius.circular(24.0)),
                                  child: Center(child: Icon(Icons.link_off))),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: (Platform.isIOS)
                  ? IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        buildIosPopUp(hateUsers, id);
                      },
                    )
                  : AndroidPopUp(
                      hateUsers, id, !hateUsers.contains(widget.userNumber)),
            ),
          ],
        ),
      ),
    );
  }

  void buildIosPopUp(List<dynamic> hateUsers, String id) {
    (!hateUsers.contains(widget.userNumber))
        ? IosShowItemPopUp(hateUsers, id)
        : IosNoShowItemPopUp(hateUsers, id);
  }

  Future<void> IosShowItemPopUp(List hateUsers, String id) async {
    final int? number = await showCupertinoModalPopup(
        context: context, builder: buildShowItemActionSheet);

    switch (number) {
      case 1:
        break;
      case 2:
        _createBlurItemDialog(id, hateUsers);
        break;
      default:
    }
  }

  Future<void> IosNoShowItemPopUp(List hateUsers, String id) async {
    final int? number = await showCupertinoModalPopup(
        context: context, builder: buildNoShowItemActionSheet);

    switch (number) {
      case 1:
        _updateHateUsers(id, widget.userNumber, hateUsers);
        break;
      default:
    }
  }

  PopupMenuButton<MenuItem> AndroidPopUp(
      List<dynamic> hateUsers, String id, condition) {
    return (condition)
        ? PopupMenuButton<MenuItem>(
            icon: Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == MenuItem.item1) {}
              if (value == MenuItem.item2) {
                _createBlurItemDialog(id, hateUsers);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('신고'),
                value: MenuItem.item1,
              ),
              PopupMenuItem(
                child: Text('관심없음'),
                value: MenuItem.item2,
              ),
            ],
          )
        : PopupMenuButton<MenuItem>(
            icon: Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == MenuItem.item1) {
                _updateHateUsers(id, widget.userNumber, hateUsers);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('차단해제'),
                value: MenuItem.item1,
              ),
            ],
          );
  }

  Widget buildShowItemActionSheet(BuildContext context) {
    return CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(1);
            },
            child: Text('신고'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(2);
            },
            child: Text('관심없음'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            '취소',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }

  Widget buildNoShowItemActionSheet(BuildContext context) {
    return CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.of(context).pop(1);
            },
            child: Text('차단해제'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            '취소',
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ));
  }

  Widget _buildNonItem() {
    return Center(
      child: Container(
          child: Text('등록된 상품이 없습니다', style: TextStyle(fontSize: 40))),
    );
  }
}
