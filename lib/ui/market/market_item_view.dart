import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../View_pages/zoom_image.dart';

class MyItemView extends StatefulWidget {
  final String id;
  const MyItemView({Key? key, required this.id}) : super(key: key);

  @override
  State<MyItemView> createState() => _MyItemViewState();
}

class _MyItemViewState extends State<MyItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "내 상품",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Builder(
        builder: (context) => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('market')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final title = snapshot.data!.get('title');
          final price = snapshot.data!.get('price');
          final content = snapshot.data!.get('content');
          final url = snapshot.data!.get('url');
          final time = snapshot.data!.get('time');
          return _buildContent(title, price, content, url, time);
        });
  }

  Widget _buildContent(
      String title, String price, String content, String url, String time) {
    return Center(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    ));
  }
}
