import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/src/data/model/event_model.dart';
import 'package:flutter_main_page/ui/View_pages/zoom_image.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../main.dart';
import '../../src/components/platform_button.dart';

class EventViewPage extends StatefulWidget {
  final EventModel event;

  const EventViewPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  BannerAd? banner;

  @override
  void initState() {
    super.initState();
    banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: UNIT_ID[Platform.isIOS ? 'ios' : 'android']!,
        listener: BannerAdListener(),
        request: AdRequest())
      ..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _header(),
                  Divider(
                    color: Colors.grey,
                  ),
                  _image(),
                  Divider(),
                  const SizedBox(
                    height: 40,
                  ),
                  _body(),
                  SizedBox(
                    height: 40,
                  ),
                  _adBanner(),
                  Divider(
                    color: Colors.grey,
                  ),
                  _button(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.event.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          "[${widget.event.author}]",
          style: const TextStyle(color: Colors.blueGrey, fontSize: 15),
        ),
        Text(
          widget.event.time,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _image() {
    return (widget.event.url != '')
        ? GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return ZoomImage(url: widget.event.url);
              }));
            },
            child: Hero(
              transitionOnUserGestures: true,
              tag: widget.event.url,
              child: Container(
                  width: Get.size.width,
                  height: Get.size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          imageUrl: widget.event.url,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Container(
                            color: Colors.black,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ))),
            ),
          )
        : Container();
  }

  Widget _body() {
    return SelectableText(
      widget.event.content,
      style: const TextStyle(
        fontSize: 20,
      ),
    );
  }

  Widget _button() {
    return PlatformBackButton(
      onPressed: () => Get.back(),
    );
  }

  Widget _adBanner() {
    return Container(
      height: 50,
      child: this.banner != null ? AdWidget(ad: this.banner!) : Container(),
    );
  }
}
