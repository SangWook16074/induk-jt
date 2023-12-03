import 'package:flutter/material.dart';
import 'package:flutter_main_page/ui/mainPage/main_home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardController extends GetxController {
  RxInt _pageIndex = 0.obs;
  RxBool _isLast = false.obs;
  int get pageIndex => _pageIndex.value;
  bool get isLast => _isLast.value;
  final page = PageController();

  void pageChanged(int index) {
    if (index == 4) {
      _pageIndex(index);
      _isLast(true);
    } else {
      _pageIndex(index);
      _isLast(false);
    }
  }

  void skip() {
    page.jumpToPage(4);
  }

  void dotClick(int index) {
    page.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void next() {
    page.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void start() {
    Get.to(() => const MainHome());
    SharedPreferences.getInstance().then((value) {
      value.setBool('showHome', true);
    });
  }
}
