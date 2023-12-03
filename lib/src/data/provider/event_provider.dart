import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_main_page/src/constants/firebase_const.dart';
import 'package:flutter_main_page/src/data/model/event_model.dart';

class EventProvider {
  static Stream<List<EventModel>> eventStreamApi() {
    return firebaseFirestore
        .collection('event')
        .snapshots()
        .map((QuerySnapshot query) {
      List<EventModel> events = [];
      for (var event in query.docs) {
        final _eventModel = EventModel.fromJson(event);
        events.add(_eventModel);
      }
      return events;
    });
  }
}
