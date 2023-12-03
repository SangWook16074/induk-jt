import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/View_pages/notice_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../main.dart';

class Job {
  String title;
  String content;
  String author;
  String time;

  Job(this.title, this.content, this.author, this.time);
}

class InfoJobPage extends StatefulWidget {
  const InfoJobPage({Key? key}) : super(key: key);

  @override
  State<InfoJobPage> createState() => _InfoJobPageState();
}

class _InfoJobPageState extends State<InfoJobPage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "취업정보",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildItem()),
          _bannerAd(),
        ],
      ),
    );
  }

  Widget _buildItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('job')
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
                        return _buildItemWidget(data['title'], data['content'],
                            data['author'], data['time']);
                      }

                      return Container();
                    });
          }),
    );
  }

  Widget _buildItemWidget(
      String title, String content, String author, String time) {
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          onTap: () {
            Navigator.push(
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
            "[취업정보] $title",
            style: const TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "작성자 : $author",
            style: const TextStyle(fontSize: 10),
          ),
        ),
        Divider(
          color: Colors.grey,
        )
      ],
    );
  }

  Widget _bannerAd() {
    return Container(
      height: 50,
      child: this.banner != null ? AdWidget(ad: banner!) : Container(),
    );
  }
}
