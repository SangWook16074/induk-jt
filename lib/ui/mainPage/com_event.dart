import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class Event {
  String id;
  String title;
  String content;
  String author;
  String time;
  int countLike;
  List likedUsersList;

  Event(this.id, this.title, this.content, this.author, this.time,
      this.countLike, this.likedUsersList);
}

class EventPage extends StatefulWidget {
  final String userNumber;
  EventPage(this.userNumber, {Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData.fallback(),
          backgroundColor: Colors.white,
          title: Text(
            "이벤트",
            style: GoogleFonts.doHyeon(
              textStyle: mainStyle,
            ),
          ),
          centerTitle: true,
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
              .collection('event')
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
                        return _buildItemWidget(
                            id,
                            data['title'],
                            data['content'],
                            data['author'],
                            data['time'],
                            data['countLike'],
                            data['likedUsersList'],
                            data['url']);
                      }

                      return Container();
                    });
          }),
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
      String url) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     (Platform.isAndroid)
        //         ? MaterialPageRoute(
        //             builder: (context) => EventViewPage(
        //                   title: title,
        //                   content: content,
        //                   author: author,
        //                   time: time,
        //                   url: url,
        //                 ))
        //         : CupertinoPageRoute(
        //             builder: (context) => EventViewPage(
        //                   title: title,
        //                   content: content,
        //                   author: author,
        //                   time: time,
        //                   url: url,
        //                 )));
      },
      child: Column(
        children: [
          ListTile(
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              title: Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(countLike.toString()),
                IconButton(
                    icon: Icon(Icons.favorite,
                        color: likedUsersList.contains(widget.userNumber)
                            ? Colors.red
                            : Colors.grey),
                    onPressed: () {
                      _updatelikedUsersList(
                          id, widget.userNumber, likedUsersList);
                      _updatecountLike(id, likedUsersList);
                    }),
              ])),
          SizedBox(
            height: 10,
          ),
          (url != '')
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
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
                      )))
              : Container(),
          Divider(),
        ],
      ),
    );
  }
}

void _updatecountLike(String docID, List likedUsersList) {
  FirebaseFirestore.instance
      .collection('event')
      .doc(docID)
      .set({'countLike': likedUsersList.length}, SetOptions(merge: true));
}

_updatelikedUsersList(String docID, String userNumber, List usersList) {
  FirebaseFirestore.instance.collection('event').doc(docID)
      // .set({'likedUsersMap': userNumber}, SetOptions(merge: true));
      .set({'likedUsersList': userCheck(usersList, userNumber)},
          SetOptions(merge: true));
}

userCheck(List usersList, String userNumber) {
  if (usersList.contains(userNumber)) {
    usersList.remove(userNumber);
  } else {
    usersList.add(userNumber);
  }
  return usersList;
}
