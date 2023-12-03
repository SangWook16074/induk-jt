import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../View_pages/com_view.dart';
import '../View_pages/notice_view.dart';

class SearchPage extends StatefulWidget {
  final String topic;
  final String userNumber;
  const SearchPage({Key? key, required this.topic, required this.userNumber})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData.fallback(),
          title: TextField(
            textInputAction: TextInputAction.search,
            controller: _searchController,
            onChanged: (text) {
              setState(() {
                _search = text;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: "글 제목",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: _buildItem(),
      ),
    );
  }

  Widget _buildItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(widget.topic)
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

                      if (_search.isEmpty) {
                        return Container();
                      }
                      if (data['title'].toString().contains(_search) &&
                          widget.topic != 'com') {
                        return _buildResultWidget(
                          id,
                          data['title'],
                          data['content'],
                          data['author'],
                          data['time'],
                        );
                      }
                      if (data['title'].toString().contains(_search) &&
                          widget.topic == 'com') {
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
    );
  }

  Widget _buildResultWidget(
      String id, String title, String content, String author, String time) {
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
