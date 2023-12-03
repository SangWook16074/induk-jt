// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_main_page/src/constants/image_path.dart';
import 'package:flutter_main_page/src/controller/app_controller.dart';
import 'package:flutter_main_page/ui/View_pages/event_view.dart';
import 'package:flutter_main_page/ui/View_pages/notice_view.dart';
import 'package:flutter_main_page/ui/View_pages/zoom_image.dart';
import 'package:flutter_main_page/ui/mainPage/main_alarm.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../src/components/event_image.dart';

final items = <Notice>[];

class Notice {
  String title;
  String content;
  String author;
  String time;

  Notice(this.title, this.content, this.author, this.time);
}

class Market {
  String title;
  String content;
  String price;
  String time;
  String url;

  Market(this.title, this.content, this.price, this.time, this.url);
}

class Com {
  String title;
  String content;
  String author;
  String time;
  String number;
  int countLike;
  List likedUsersList;
  List hateUsers;
  String? url;

  Com(this.title, this.author, this.content, this.time, this.number,
      this.countLike, this.likedUsersList, this.hateUsers, this.url);
}

class MainHome extends StatefulWidget {
  const MainHome({
    Key? key,
  }) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url,
        mode: LaunchMode.inAppWebView,
        webViewConfiguration: const WebViewConfiguration(
            enableJavaScript: true, enableDomStorage: true))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: (userInfo.userInfo!.isAdmin != null)
      //     ? SpeedDial(
      //         gradientBoxShape: BoxShape.circle,
      //         spaceBetweenChildren: 10,
      //         spacing: 10,
      //         icon: Icons.manage_accounts,
      //         overlayOpacity: 0.6,
      //         overlayColor: Colors.black,
      //         children: [
      //           SpeedDialChild(
      //               child: Icon(Icons.edit_notifications),
      //               label: '공지관리',
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     (Platform.isAndroid)
      //                         ? MaterialPageRoute(
      //                             builder: (context) => NoticeManagePage())
      //                         : CupertinoPageRoute(
      //                             builder: (context) => NoticeManagePage()));
      //               }),
      //           SpeedDialChild(
      //               child: Icon(Icons.event_available),
      //               label: '이벤트관리',
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     (Platform.isAndroid)
      //                         ? MaterialPageRoute(
      //                             builder: (context) => EventManagePage())
      //                         : CupertinoPageRoute(
      //                             builder: (context) => EventManagePage()));
      //               }),
      //           SpeedDialChild(
      //               child: Icon(Icons.lightbulb),
      //               label: '취업정보관리',
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     (Platform.isAndroid)
      //                         ? MaterialPageRoute(
      //                             builder: (context) => JobManagePage())
      //                         : CupertinoPageRoute(
      //                             builder: (context) => JobManagePage()));
      //               }),
      //           SpeedDialChild(
      //               child: Icon(Icons.message),
      //               label: '커뮤니티 관리',
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     (Platform.isAndroid)
      //                         ? MaterialPageRoute(
      //                             builder: (context) => ComManagePage())
      //                         : CupertinoPageRoute(
      //                             builder: (context) => ComManagePage()));
      //               }),
      //           SpeedDialChild(
      //               child: Icon(Icons.photo_library),
      //               label: '배너사진관리',
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     (Platform.isAndroid)
      //                         ? MaterialPageRoute(
      //                             builder: (context) => AddPhotoPage())
      //                         : CupertinoPageRoute(
      //                             builder: (context) => AddPhotoPage()));
      //               }),
      //           SpeedDialChild(
      //               child: Icon(Icons.question_answer),
      //               label: 'Q / A 관리',
      //               onTap: () {
      //                 Navigator.push(
      //                     context,
      //                     (Platform.isAndroid)
      //                         ? MaterialPageRoute(
      //                             builder: (context) => QuestionManagePage())
      //                         : CupertinoPageRoute(
      //                             builder: (context) => QuestionManagePage()));
      //               }),
      //         ],
      //       )
      //     : null,
      // endDrawer: NavigationDrawerWidget(
      //     userNumber: widget.userNumber,
      //     user: widget.user,
      //     isAdmin: widget.isAdmin),
      appBar: AppBar(
        title: Image.asset(
          ImagePath.logo,
          height: 30,
          width: 30,
        ),
        actions: [
          IconButton(
              onPressed: () => Get.to(() => MainAlarm()),
              icon: Icon(
                Icons.notifications_active,
              )),
          Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(
                  Icons.menu,
                ));
          })
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          _buildIconNavigator(),
          SizedBox(
            height: 20,
          ),
          _eventImage(),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey, width: 1)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              '공지사항',
                              style: GoogleFonts.doHyeon(
                                textStyle: mainStyle,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                // (Platform.isAndroid)
                                //     ? Navigator.of(context).push(
                                //         CustomPageRightRoute(
                                //             child: NoticePage(
                                //                 userInfo.userInfo!.userNumber)))
                                //     : Navigator.of(context).push(
                                //         CupertinoPageRoute(builder: (context) {
                                //         return NoticePage(
                                //             userInfo.userInfo!.userNumber);
                                //       }));
                              },
                              child: Text(
                                '더보기',
                                style: TextStyle(color: Colors.blueGrey),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildNotice(),
                  ],
                )),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey, width: 1)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              '최근 등록된 글',
                              style: GoogleFonts.doHyeon(
                                textStyle: mainStyle,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                // (Platform.isAndroid)
                                //     ? Navigator.of(context).push(
                                //         CustomPageRightRoute(
                                //             child: ComPage(
                                //                 userInfo.userInfo!.userNumber)))
                                //     : Navigator.of(context).push(
                                //         CupertinoPageRoute(builder: (context) {
                                //         return ComPage(
                                //             userInfo.userInfo!.userNumber);
                                //       }));
                              },
                              child: Text(
                                '더보기',
                                style: TextStyle(color: Colors.blueGrey),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // _buildCom(),
                  ],
                )),
          ),
          SizedBox(
            height: 30,
          ),
          _buildMarket(),
          SizedBox(
            height: 30,
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.width + 100,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  '학과 소식',
                                  style: GoogleFonts.doHyeon(
                                    textStyle: mainStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: _buildBannerImage(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildNotice() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notice')
            .orderBy('time', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator.adaptive());
          }
          final documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return _buildNonItem();
          } else {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: documents
                  .map((doc) => _buildItemNotice(doc, context))
                  .toList(),
            );
          }
        });
  }

  // Widget _buildCom() {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection('com')
  //           .orderBy('time', descending: true)
  //           .limit(5)
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return const Align(
  //               alignment: Alignment.center,
  //               child: CircularProgressIndicator.adaptive());
  //         }
  //         final documents = snapshot.data!.docs;
  //         if (documents.isEmpty) {
  //           return _buildNonItem();
  //         } else {
  //           return ListView(
  //             physics: const NeverScrollableScrollPhysics(),
  //             shrinkWrap: true,
  //             children:
  //                 documents.map((doc) => _buildItemCom(doc, context)).toList(),
  //           );
  //         }
  //       });
  // }

  Widget _buildIconNavigator() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    Uri uri = Uri(
                      scheme: 'https',
                      host: 'www.induk.ac.kr',
                      path: '/KR/index.do',
                    );
                    _launchUrl(uri);
                  },
                  icon: Icon(
                    Icons.account_balance,
                    size: 30,
                  )),
              Text(
                '대학홈',
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    Uri uri = Uri(
                      scheme: 'https',
                      host: 'portal.induk.ac.kr',
                    );
                    _launchUrl(uri);
                  },
                  icon: Icon(
                    Icons.language,
                    size: 30,
                  )),
              Text(
                '대학포털',
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          // Column(
          //   children: [
          //     IconButton(
          //         onPressed: () {
          //           Uri uri = Uri(
          //               scheme: 'https',
          //               host: 'www.induk.ac.kr',
          //               path: '/KR/cms/CM_CN01_CON/index.do',
          //               query: '?MENU_SN=812');
          //           _launchUrl(uri);
          //         },
          //         icon: Icon(
          //           Icons.post_add,
          //           size: 30,
          //         )),
          //     Text(
          //       '학과소개',
          //       style: TextStyle(fontSize: 13),
          //     )
          //   ],
          // ),
          Column(
            children: [
              IconButton(
                  onPressed: () {
                    Uri uri = Uri(scheme: 'https', host: 'jjam.induk.ac.kr');
                    _launchUrl(uri);
                  },
                  icon: Icon(
                    Icons.menu_book,
                    size: 30,
                  )),
              Text(
                '비교과',
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          SizedBox(),
        ],
      ),
    );
  }

  Widget _buildBannerImage() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('eventImage').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          final documents = snapshot.data!.docs;

          return CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
            ),
            items: documents.map((doc) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push((Platform.isAndroid)
                          ? MaterialPageRoute(builder: (context) {
                              return ZoomImage(url: doc['url']);
                            })
                          : CupertinoPageRoute(builder: (context) {
                              return ZoomImage(url: doc['url']);
                            }));
                    },
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: doc['url'],
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: doc['url'],
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Container(
                                color: Colors.black,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )),
                    ),
                  );
                },
              );
            }).toList(),
          );
        });
  }

  // Widget _buildItemCom(DocumentSnapshot doc, BuildContext context) {
  //   final com = Com(
  //       doc['title'],
  //       doc['author'],
  //       doc['content'],
  //       doc['time'],
  //       doc['number'],
  //       doc['countLike'],
  //       doc['likedUsersList'],
  //       doc['hateUsers'],
  //       doc['url']);
  //   if (doc['hateUsers'].contains(userInfo.userInfo!.userNumber)) {
  //     return Column(
  //       children: [
  //         ListTile(
  //           visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
  //           onTap: () {
  //             toastMessage('차단된 글은 볼 수 없습니다.');
  //           },
  //           title: Text(
  //             '사용자가 차단한 글',
  //             style: const TextStyle(
  //                 fontSize: 17,
  //                 color: Colors.grey,
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         ),
  //         Divider(
  //           color: Colors.grey,
  //         )
  //       ],
  //     );
  //   }
  //   return Column(
  //     children: [
  //       ListTile(
  //         visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
  //         onTap: () {
  //           // (com.url == '')
  //           //     ? Navigator.push(
  //           //         context,
  //           //         (Platform.isAndroid)
  //           //             ? MaterialPageRoute(
  //           //                 builder: (context) => ComViewPage(
  //           //                       title: com.title,
  //           //                       content: com.content,
  //           //                       author: '익명',
  //           //                       time: com.time,
  //           //                       id: doc.id,
  //           //                       user: userInfo.userInfo!.userNumber,
  //           //                       countLike: com.countLike,
  //           //                       likedUsersList: com.likedUsersList,
  //           //                       hateUsers: com.hateUsers,
  //           //                     ))
  //           //             : CupertinoPageRoute(
  //           //                 builder: (context) => ComViewPage(
  //           //                     title: com.title,
  //           //                     content: com.content,
  //           //                     author: '익명',
  //           //                     time: com.time,
  //           //                     id: doc.id,
  //           //                     user: userInfo.userInfo!.userNumber,
  //           //                     countLike: com.countLike,
  //           //                     likedUsersList: com.likedUsersList,
  //           //                     hateUsers: com.hateUsers)))
  //           //     : Navigator.push(
  //           //         context,
  //           //         (Platform.isAndroid)
  //           //             ? MaterialPageRoute(
  //           //                 builder: (context) => ComViewPage(
  //           //                     title: com.title,
  //           //                     content: com.content,
  //           //                     author: '익명',
  //           //                     time: com.time,
  //           //                     id: doc.id,
  //           //                     url: com.url!,
  //           //                     user: userInfo.userInfo!.userNumber,
  //           //                     countLike: com.countLike,
  //           //                     likedUsersList: com.likedUsersList))
  //           //             : CupertinoPageRoute(
  //           //                 builder: (context) => ComViewPage(
  //           //                     title: com.title,
  //           //                     content: com.content,
  //           //                     author: '익명',
  //           //                     time: com.time,
  //           //                     id: doc.id,
  //           //                     url: com.url!,
  //           //                     user: userInfo.userInfo!.userNumber,
  //           //                     countLike: com.countLike,
  //           //                     likedUsersList: com.likedUsersList)));
  //         },
  //         title: Text(
  //           com.title,
  //           style: const TextStyle(
  //               fontSize: 17,
  //               color: Colors.blueGrey,
  //               fontWeight: FontWeight.bold),
  //         ),
  //         subtitle: Text(
  //           "익명 | ${com.time}",
  //           style: const TextStyle(fontSize: 10),
  //         ),
  //         trailing: (doc['url'] != '')
  //             ? Container(
  //                 margin: const EdgeInsets.symmetric(horizontal: 5.0),
  //                 child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(8.0),
  //                     child: Container(
  //                       width: 70,
  //                       child: CachedNetworkImage(
  //                         imageUrl: doc['url']!,
  //                         fit: BoxFit.fitWidth,
  //                         placeholder: (context, url) => Container(
  //                           color: Colors.black,
  //                         ),
  //                         errorWidget: (context, url, error) =>
  //                             Icon(Icons.error),
  //                       ),
  //                     )))
  //             : null,
  //       ),
  //       Divider(
  //         color: Colors.grey,
  //       )
  //     ],
  //   );
  // }

  Widget _buildItemNotice(DocumentSnapshot doc, BuildContext context) {
    final notice =
        Notice(doc['title'], doc['content'], doc['author'], doc['time']);
    return Column(
      children: [
        ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          onTap: () {
            Navigator.push(
                context,
                (Platform.isAndroid)
                    ? MaterialPageRoute(
                        builder: (context) => NoticeViewPage(notice.title,
                            notice.content, notice.author, notice.time))
                    : CupertinoPageRoute(
                        builder: (context) => NoticeViewPage(notice.title,
                            notice.content, notice.author, notice.time)));
          },
          title: Text(
            notice.title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey),
          ),
          subtitle: Text(
            "${notice.author} | ${notice.time}",
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildNonItem() {
    return Container(
      height: 280,
      child: const Center(
          child: Text(
        '아직 등록된 글이 없습니다.',
        style: TextStyle(
            color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _buildEvent() {
    return GetX<AppController>(builder: (_) {
      final _event = _.events;
      return CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: true,
          height: Get.size.width,
          enlargeCenterPage: true,
        ),
        itemCount: _event.length,
        itemBuilder: (context, index, realIndex) => (_event.length == 0)
            ? Center(
                child: Text('이벤트 없음'),
              )
            : EventImage(
                event: _event[index],
                onPressed: () =>
                    Get.to(() => EventViewPage(event: _event[index])),
              ),
      );
    });
  }

  Widget _buildMarket() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey, width: 1)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        '전공서 중고마켓',
                        style: GoogleFonts.doHyeon(
                          textStyle: mainStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('사용하지 않는 전공서를 필요한 학과사람들에게 중고로 판매해보세요!'),
                ElevatedButton.icon(
                    icon: Icon(Icons.arrow_right_alt),
                    onPressed: () {
                      // (Platform.isAndroid)
                      //     ? Navigator.of(context).push(CustomPageRightRoute(
                      //         child: MarketPage(
                      //         userNumber: userInfo.userInfo!.userNumber,
                      //       )))
                      //     : Navigator.of(context)
                      //         .push(CupertinoPageRoute(builder: (context) {
                      //         return MarketPage(
                      //           userNumber: userInfo.userInfo!.userNumber,
                      //         );
                      //       }));
                    },
                    label: Text(
                      '마켓으로',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )),
    );
  }

  Widget _buildMarketItem() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('market')
            .orderBy('time', descending: true)
            .limit(5)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator.adaptive());
          }
          final documents = snapshot.data!.docs;
          if (documents.isEmpty) {
            return _buildNonItem();
          } else {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children:
                  documents.map((doc) => _MarketItem(doc, context)).toList(),
            );
          }
        });
  }

  Widget _MarketItem(DocumentSnapshot doc, BuildContext context) {
    final market = Market(
        doc['title'], doc['content'], doc['price'], doc['time'], doc['url']);
    return Container(
      child: Column(
        children: [
          ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            onTap: () {
              // Navigator.push(
              //     context,
              //     (Platform.isAndroid)
              //         ? MaterialPageRoute(
              //             builder: (context) => NoticeViewPage(notice.title,
              //                 notice.content, notice.author, notice.time))
              //         : CupertinoPageRoute(
              //             builder: (context) => NoticeViewPage(notice.title,
              //                 notice.content, notice.author, notice.time)));
            },
            title: Text(
              market.title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            subtitle: Text(
              "익명 | ${market.time}",
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _eventImage() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Container(
            height: MediaQuery.of(context).size.width + 100,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey, width: 1)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  Container(
                    height: 40,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            '학생회 이벤트',
                            style: GoogleFonts.doHyeon(
                              textStyle: mainStyle,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              // Navigator.of(context).push(
                              //     MaterialPageRoute(builder: (context) {
                              //   return EventPage(
                              //       userInfo.userInfo!.userNumber);
                              // }));
                            },
                            child: Text(
                              '더보기',
                              style: TextStyle(color: Colors.blueGrey),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: _buildEvent(),
        ),
      ],
    );
  }
}
