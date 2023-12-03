import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:flutter_main_page/ui/Update_Page/userinfo_update.dart';
import 'package:flutter_main_page/ui/market/com_market.dart';
import 'package:flutter_main_page/ui/others/QandAhome.dart';
import 'package:flutter_main_page/ui/others/delete_user.dart';
import 'package:flutter_main_page/ui/others/feedback.dart';
import 'package:flutter_main_page/ui/loginPage/reset_pass.dart';
import 'package:flutter_main_page/ui/mainPage/com_notice.dart';
import 'package:flutter_main_page/ui/others/calculate.dart';
import 'package:flutter_main_page/ui/mainPage/myContentDelete.dart';
import 'package:flutter_main_page/ui/others/intro.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';
import '../../ui/loginPage/login_page.dart';
import '../../ui/mainPage/com_community.dart';
import '../../ui/mainPage/com_event.dart';
import '../../ui/mainPage/com_info_job.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final String userNumber;
  final String user;
  final bool isAdmin;
  NavigationDrawerWidget(
      {Key? key,
      required this.user,
      required this.isAdmin,
      required this.userNumber})
      : super(key: key);
  final _subStyle = TextStyle(fontSize: 20, color: Colors.black);
  final padding = EdgeInsets.symmetric(horizontal: 20);
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _deleteAutoLoginStatus() async {
    prefs.setBool('autoLoginStatus', false);
    prefs.remove('userNumber');
    prefs.remove('user');
    prefs.remove('isAdmin');
  }

  void _createItemDialog(BuildContext context) {
    if (prefs.getBool('isSubscribe') == true) {
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
                    children: const [
                      Text(
                          '푸시 알림을 해제하시겠습니까?\n알림을 해제하시면 공지, 취업정보, 이벤트 등의 등록사항을 볼 수 없습니다.')
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          FirebaseMessaging.instance
                              .unsubscribeFromTopic("connectTopic");
                          prefs.setBool('isSubscribe', false);
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
                    children: const [
                      Text(
                          '푸시 알림을 해제하시겠습니까?\n알림을 해제하시면 공지, 취업정보, 이벤트 등의 등록사항을 볼 수 없습니다.')
                    ],
                  ),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () {
                          FirebaseMessaging.instance
                              .unsubscribeFromTopic("connectTopic");
                          prefs.setBool('isSubscribe', false);
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
    } else {
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
                    children: const [Text('푸시 알림을 설정하시겠습니까?')],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          FirebaseMessaging.instance
                              .subscribeToTopic("connectTopic");
                          prefs.setBool('isSubscribe', true);
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
                    children: const [Text('푸시 알림을 설정하시겠습니까?')],
                  ),
                  actions: [
                    CupertinoDialogAction(
                        onPressed: () {
                          FirebaseMessaging.instance
                              .subscribeToTopic("connectTopic");
                          prefs.setBool('isSubscribe', true);
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.white,
        child: ListView(padding: padding, children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          _buildUserInfo(context),
          Divider(
            color: Colors.black,
          ),
          Text(
            "Community",
            style: GoogleFonts.doHyeon(
              textStyle: _subStyle,
            ),
          ),
          SizedBox(),
          _buildMenuItem(
            context,
            text: '공지사항',
            icon: Icons.notifications,
            onTap: NoticePage(this.user),
          ),
          _buildMenuItem(
            context,
            text: '학과 이벤트',
            icon: Icons.event,
            onTap: EventPage(this.user),
          ),
          _buildMenuItem(
            context,
            text: '취업정보',
            icon: Icons.lightbulb,
            onTap: InfoJobPage(),
          ),
          _buildMenuItem(
            context,
            text: '커뮤니티',
            icon: Icons.message,
            onTap: ComPage(
              this.userNumber,
            ),
          ),
          _buildMenuItem(
            context,
            text: '전공서 중고마켓',
            icon: Icons.wallet_giftcard,
            onTap: MarketPage(
              userNumber: this.userNumber,
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Text(
            "My Page",
            style: GoogleFonts.doHyeon(
              textStyle: _subStyle,
            ),
          ),
          _buildMenuItem(
            context,
            text: '1:1 문의',
            icon: Icons.question_answer,
            onTap: QuestionHome(
              userNumber: this.userNumber,
            ),
          ),
          _buildMenuItem(
            context,
            text: '내가 쓴 글',
            icon: Icons.edit,
            onTap: MyContentManagePage(
              this.userNumber,
            ),
          ),
          _buildMenuItem(context,
              text: '비밀번호 변경', icon: Icons.password, onTap: ResetPassPage()),
          _buildMenuItem(context,
              text: '이메일 변경', icon: Icons.email, onTap: UserInfoUpdate()),
          Divider(
            color: Colors.black,
          ),
          Text(
            "Others",
            style: GoogleFonts.doHyeon(
              textStyle: _subStyle,
            ),
          ),
          ListTile(
            onTap: () {
              _createItemDialog(context);
            },
            leading: Icon(
              Icons.settings,
              color: Colors.black87,
            ),
            title: Text(
              "알림 설정",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
          _buildMenuItem(context,
              text: '학점 계산기', icon: Icons.calculate, onTap: CalculatePage()),
          _buildMenuItem(context,
              text: '피드백',
              icon: Icons.feedback,
              onTap: FeedBackPage(userNumber: this.userNumber)),
          _buildMenuItem(
            context,
            text: '정보',
            icon: Icons.info,
            onTap: Intro(),
          ),
          _buildMenuItem(
            context,
            text: '회원탈퇴',
            icon: Icons.remove_circle,
            onTap: UserDelete(
              userNumber: this.userNumber,
            ),
          ),
          Divider(
            color: Colors.black,
          ),
          Text(
            "More + ",
            style: GoogleFonts.doHyeon(
              textStyle: _subStyle,
            ),
          ),
          _buildIcon(),
          SizedBox(
            height: 30,
          )
        ]),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_circle_rounded,
            size: 40,
            color: Colors.black54,
          ),
          Column(
            children: [
              SizedBox(
                child: Text(
                  '${this.user}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
              ),
              Text(
                '${this.userNumber}',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black87,
              size: 20,
            ),
            color: Color.fromRGBO(104, 103, 103, 100),
            onPressed: () async {
              _deleteAutoLoginStatus();
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  (Platform.isAndroid)
                      ? MaterialPageRoute(builder: (context) => LoginPage())
                      : CupertinoPageRoute(builder: (context) => LoginPage()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String text, required IconData icon, required Widget onTap}) {
    final color = Colors.black87;

    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push((Platform.isAndroid)
            ? MaterialPageRoute(builder: (context) {
                return onTap;
              })
            : CupertinoPageRoute(builder: (context) {
                return onTap;
              }));
      },
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIcon() {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              Uri uri = Uri(
                  scheme: 'https', host: 'www.facebook.com', path: '/IC2019');
              _launchUrl(uri);
            },
            child: Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/Images/title_facebook.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Uri uri = Uri(
                  scheme: 'https',
                  host: 'www.instagram.com',
                  path: '/induk_jt');
              _launchUrl(uri);
            },
            child: Container(
              width: 50,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/Images/title_instagram.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
