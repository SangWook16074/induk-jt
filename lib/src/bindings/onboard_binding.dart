import 'package:flutter_main_page/src/controller/onboard_controller.dart';
import 'package:get/get.dart';

class OnboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(OnboardController());
  }
}
