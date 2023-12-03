import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../main.dart';

class NoticeViewPage extends StatefulWidget {
  final String title;
  final String content;
  final String author;
  final String time;
  const NoticeViewPage(this.title, this.content, this.author, this.time,
      {Key? key})
      : super(key: key);

  @override
  State<NoticeViewPage> createState() => _NoticeViewPageState();
}

class _NoticeViewPageState extends State<NoticeViewPage> {
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
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
            ),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "[${widget.author}]",
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 15),
                ),
                Text(
                  widget.time,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Divider(
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  widget.content,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 50,
                  child:
                      this.banner != null ? AdWidget(ad: banner!) : Container(),
                ),
                Divider(
                  color: Colors.grey,
                ),
                (Platform.isAndroid)
                    ? SizedBox(
                        width: 200,
                        child: ElevatedButton(
                            //취소 버튼

                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              padding: const EdgeInsets.all(16.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "목록",
                                  style: TextStyle(
                                      fontSize: 15, letterSpacing: 4.0),
                                ),
                                Icon(Icons.reorder),
                              ],
                            )),
                      )
                    : SizedBox(
                        width: 200,
                        child: CupertinoButton(
                            //취소 버튼

                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.blueGrey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "목록",
                                  style: TextStyle(
                                      fontSize: 15, letterSpacing: 4.0),
                                ),
                                Icon(Icons.reorder),
                              ],
                            )),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
