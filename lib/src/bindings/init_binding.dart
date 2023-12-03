import 'package:flutter_main_page/src/controller/auth_controller.dart';
import 'package:flutter_main_page/src/controller/notice_controller.dart';
import 'package:get/get.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NotificationController(), permanent: true);
    Get.put(AuthController(), permanent: true);
  }
}
