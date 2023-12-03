import 'package:flutter_main_page/src/data/model/event_model.dart';
import 'package:flutter_main_page/src/data/repository/event_repository.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  late Rx<List<EventModel>> _events = Rx<List<EventModel>>([]);
  List<EventModel> get events => _events.value;

  @override
  void onReady() {
    super.onInit();
    _events.bindStream(EventRepository.fetchAllEvent());
  }
}
