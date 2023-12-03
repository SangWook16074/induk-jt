// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, avoid_unnecessary_containers

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/View_pages/notice_view.dart';
import 'package:flutter_main_page/ui/mainPage/com_search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../main.dart';
import '../../src/components/custom_page_route.dart';

class NoticePage extends StatefulWidget {
  final String user;

  const NoticePage(this.user, {Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  var _search = TextEditingController();

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

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '공지사항',
            style: GoogleFonts.doHyeon(
              textStyle: mainStyle,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      (Platform.isAndroid)
                          ? CustomPageRightRoute(
                              child: SearchPage(
                              topic: 'notice',
                              userNumber: widget.user,
                            ))
                          : CupertinoPageRoute(builder: (context) {
                              return SearchPage(
                                topic: 'notice',
                                userNumber: widget.user,
                              );
                            }));
                },
                icon: Icon(Icons.search))
          ],
          iconTheme: IconThemeData.fallback(),
          shadowColor: Colors.white,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            _buildItem(),
            _bannerAd(),
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
                .collection('notice')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                        if (snapshot.hasData) {
                          return _buildItemWidget(context, data['title'],
                              data['content'], data['author'], data['time']);
                        }

                        return Container();
                      });
            }),
      ),
    );
  }

  Widget _bannerAd() {
    return Container(
      height: 50,
      child: this.banner != null ? AdWidget(ad: banner!) : Container(),
    );
  }

  Widget _buildItemWidget(BuildContext context, String title, String content,
      String author, String time) {
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          onTap: () {
            Navigator.pushReplacement(
                context,
                (Platform.isAndroid)
                    ? MaterialPageRoute(
                        builder: (context) =>
                            NoticeViewPage(title, content, author, time))
                    : CupertinoPageRoute(
                        builder: (context) =>
                            NoticeViewPage(title, content, author, time)));
          },
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "$author | $time",
            style: const TextStyle(fontSize: 10),
          ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}
