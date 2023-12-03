import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/market/market_add.dart';
import 'package:flutter_main_page/ui/market/market_myinfo.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import 'market_chat.dart';
import 'market_home.dart';

class MarketPage extends StatefulWidget {
  final String userNumber;
  MarketPage({Key? key, required this.userNumber}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  var _index = 0;

  late List _pages = <Widget>[
    MarketHomePage(userNumber: widget.userNumber),
    MarketChatPage(userNumber: widget.userNumber),
    MarketMyInfoPage(userNumber: widget.userNumber),
  ];

  late List _appBar = <AppBar>[
    AppBar(
      title: Text(
        "전공서 중고마켓",
        style: GoogleFonts.doHyeon(
          textStyle: mainStyle,
        ),
      ),
      iconTheme: IconThemeData.fallback(),
      backgroundColor: Colors.white,
      centerTitle: true,
    ),
    AppBar(
      title: Text(
        "채팅",
        style: GoogleFonts.doHyeon(
          textStyle: mainStyle,
        ),
      ),
      iconTheme: IconThemeData.fallback(),
      backgroundColor: Colors.white,
      centerTitle: true,
    ),
    AppBar(
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        extendBody: true,
        floatingActionButton: (_index == 0)
            ? FloatingActionButton.extended(
                icon: Icon(Icons.add),
                label: Text('상품등록'),
                onPressed: () {
                  Navigator.of(context).push((Platform.isAndroid)
                      ? MaterialPageRoute(builder: (context) {
                          return MarkerAddPage(
                            userNumber: widget.userNumber,
                          );
                        })
                      : CupertinoPageRoute(builder: (context) {
                          return MarkerAddPage(
                            userNumber: widget.userNumber,
                          );
                        }));
                },
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: _appBar[_index],
        body: _pages[_index],
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buttomTabItem(0, Icon(Icons.storefront_rounded)),
              _buttomTabItem(1, Icon(Icons.message)),
              _buttomTabItem(2, Icon(Icons.account_circle)),
            ],
          ),
        ));
  }

  Widget _buttomTabItem(int index, Icon icon) {
    var isSelected = (index == _index) ? true : false;
    return IconButton(
      onPressed: () {
        if (index != _index) {
          setState(() {
            _index = index;
          });
          return;
        }
      },
      icon: icon,
      color: (isSelected == true) ? Colors.blueGrey : null,
    );
  }
}
