import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/View_pages/com_view.dart';
import 'package:flutter_main_page/ui/WritePages/com_write_com.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../main.dart';
import '../../src/components/custom_page_route.dart';
import 'com_search.dart';

class Com {
  String title;
  String content;
  String author;
  String time;
  int countLike;
  List likedUsersList;

  Com(this.title, this.author, this.content, this.time, this.countLike,
      this.likedUsersList);
}

class ComPage extends StatefulWidget {
  final String userNumber;
  ComPage(this.userNumber, {Key? key}) : super(key: key);

  @override
  State<ComPage> createState() => _ComPageState();
}

class _ComPageState extends State<ComPage> {
  BannerAd? banner;

  @override
  void initState() {
    super.initState();
    banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: UNIT_ID[Platform.isIOS ? 'ios' : 'android']!,
        listener: BannerAdListener(
          onAdLoaded: (ad) {},
          onAdFailedToLoad: (ad, error) {},
        ),
        request: AdRequest())
      ..load();
  }

  userCheck(List hateUsers) {
    if (hateUsers.contains(widget.userNumber)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.edit),
          label: Text("글쓰기"),
          onPressed: () {
            Navigator.of(context).push((Platform.isAndroid)
                ? MaterialPageRoute(builder: (contexst) {
                    return WriteComPage(userNumber: widget.userNumber);
                  })
                : CupertinoPageRoute(builder: (contexst) {
                    return WriteComPage(userNumber: widget.userNumber);
                  }));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      (Platform.isAndroid)
                          ? CustomPageRightRoute(
                              child: SearchPage(
                              topic: 'com',
                              userNumber: widget.userNumber,
                            ))
                          : CupertinoPageRoute(builder: (context) {
                              return SearchPage(
                                topic: 'com',
                                userNumber: widget.userNumber,
                              );
                            }));
                },
                icon: Icon(Icons.search))
          ],
          iconTheme: IconThemeData.fallback(),
          backgroundColor: Colors.white,
          title: Text(
            "커뮤니티",
            style: GoogleFonts.doHyeon(
              textStyle: mainStyle,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildItem(),
            _bannerAd(),
          ],
        ));
  }

  Widget _bannerAd() {
    return Container(
      height: 50,
      child: this.banner != null ? AdWidget(ad: banner!) : Container(),
    );
  }

  Widget _buildItem() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('com')
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
                        var id = snapshot.data!.docs[index].id;

                        if (snapshot.hasData) {
                          if (data['url'] == "") {
                            return _buildItemWidget(
                              id,
                              data['title'],
                              data['content'],
                              data['author'],
                              data['time'],
                              data['countLike'],
                              data['likedUsersList'],
                              data['hateUsers'],
                            );
                          } else {
                            return _buildItemImageWidget(
                                id,
                                data['title'],
                                data['content'],
                                data['author'],
                                data['time'],
                                data['countLike'],
                                data['likedUsersList'],
                                data['hateUsers'],
                                data['url']);
                          }
                        }

                        return Container();
                      });
            }),
      ),
    );
  }

  Widget _buildItemImageWidget(
      String id,
      String title,
      String content,
      String author,
      String time,
      int countLike,
      List likedUsersList,
      List hateUsers,
      String? url) {
    if (hateUsers.contains(widget.userNumber)) {
      return Column(
        children: [
          ListTile(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            onTap: () {
              toastMessage('차단한 글은 볼 수 없습니다');
            },
            title: Text(
              '사용자가 차단한 글',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      );
    }
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          onTap: () {
            Navigator.push(
                context,
                (Platform.isAndroid)
                    ? MaterialPageRoute(
                        builder: (context) => ComViewPage(
                            title: title,
                            content: content,
                            author: '익명',
                            time: time,
                            id: id,
                            url: url!,
                            user: widget.userNumber,
                            countLike: countLike,
                            likedUsersList: likedUsersList))
                    : CupertinoPageRoute(
                        builder: (context) => ComViewPage(
                            title: title,
                            content: content,
                            author: '익명',
                            time: time,
                            id: id,
                            url: url!,
                            user: widget.userNumber,
                            countLike: countLike,
                            likedUsersList: likedUsersList)));
          },
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "익명 | $time",
                style: const TextStyle(fontSize: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.thumb_up, size: 15, color: Colors.purple),
                  Text('  $countLike')
                ],
              )
            ],
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        width: 70,
                        child: CachedNetworkImage(
                          imageUrl: url!,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => Container(
                            color: Colors.black,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ))),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }

  Widget _buildItemWidget(
    String id,
    String title,
    String content,
    String author,
    String time,
    int countLike,
    List likedUsersList,
    List hateUsers,
  ) {
    if (hateUsers.contains(widget.userNumber)) {
      return Column(
        children: [
          ListTile(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            onTap: () {
              toastMessage('차단한 글은 볼 수 없습니다');
            },
            title: Text(
              '사용자가 차단한 글',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      );
    }
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          onTap: () {
            Navigator.push(
                context,
                (Platform.isAndroid)
                    ? MaterialPageRoute(
                        builder: (context) => ComViewPage(
                              title: title,
                              content: content,
                              author: '익명',
                              time: time,
                              id: id,
                              user: widget.userNumber,
                              countLike: countLike,
                              likedUsersList: likedUsersList,
                              hateUsers: hateUsers,
                            ))
                    : CupertinoPageRoute(
                        builder: (context) => ComViewPage(
                              title: title,
                              content: content,
                              author: '익명',
                              time: time,
                              id: id,
                              user: widget.userNumber,
                              countLike: countLike,
                              likedUsersList: likedUsersList,
                              hateUsers: hateUsers,
                            )));
          },
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "익명 | $time",
                style: const TextStyle(fontSize: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.thumb_up, size: 15, color: Colors.purple),
                  Text('  $countLike')
                ],
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}
