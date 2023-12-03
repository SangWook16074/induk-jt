import 'package:flutter_main_page/src/data/provider/event_provider.dart';

class EventRepository {
  static fetchAllEvent() => EventProvider.eventStreamApi();
}
