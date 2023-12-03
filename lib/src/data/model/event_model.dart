import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  late String documentId;
  late String author;
  late String content;
  late int countLike;
  late List likedUsersList;
  late String time;
  late String title;
  late String url;

  EventModel({
    required this.title,
    required this.url,
  });

  EventModel.fromJson(DocumentSnapshot json) {
    documentId = json.id;
    author = json['author'];
    content = json['content'];
    countLike = json['countLike'];
    likedUsersList = json['likedUsersList'];
    time = json['time'];
    title = json['title'];
    url = json['url'] ?? '';
  }

  EventModel.toJson() {}
}
