import 'package:flutter/material.dart';
import 'package:flutter_main_page/src/bindings/app_binding.dart';
import 'package:flutter_main_page/src/bindings/onboard_binding.dart';
import 'package:flutter_main_page/src/data/model/user_model.dart';
import 'package:flutter_main_page/src/data/repository/user_repository.dart';
import 'package:flutter_main_page/src/service/toast_message.dart';
import 'package:flutter_main_page/ui/loginPage/login_page.dart';
import 'package:flutter_main_page/ui/mainPage/main_home.dart';
import 'package:flutter_main_page/ui/others/introduce.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/firebase_const.dart';

class AuthController extends GetxController {
  final TextEditingController number = TextEditingController();
  final TextEditingController password = TextEditingController();

  late Rx<User?> _user;
  late Rx<UserModel?> _userInfo;
  RxBool _loading = false.obs;

  User? get user => _user.value;
  UserModel? get userInfo => _userInfo.value;
  bool get loading => _loading.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, _moveToPage);
  }

  void _moveToPage(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
      return;
    }
    moveAfterLogin();
  }

  void _signUp() {}

  void checkUserInfo() {
    try {
      _loading(true);
      firebaseFirestore
          .collection('UserInfo')
          .doc(number.text.trim())
          .get()
          .then((userInfo) {
        if (!userInfo.exists) {
          Message.showToastMessage('존재하지 않는 학번입니다.');
          _loading(false);
          return;
        }

        _signIn(userInfo['email']);
      });
    } catch (e) {
      Message.showToastMessage('에러');
    }
  }

  Future<void> _signIn(String email) async {
    try {
      auth
          .signInWithEmailAndPassword(
              email: email, password: password.text.trim())
          .then((value) {
        if (!value.user!.emailVerified) {
          Message.showToastMessage('이메일 인증을 완료해야 합니다.');
          // Get.off(() => const OnBoardingPage(), binding: OnboardBinding());
          _loading(false);
          return;
        }
        print('로그인 성공 !');
        _loading(false);
        moveAfterLogin();

        number.clear();
        password.clear();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Message.showToastMessage('비밀번호가 다릅니다');
        _loading(false);
        return;
      }

      Message.showToastMessage('잠시 후에 다시 시도해주세요');
      _loading(false);
    }
  }

  void signOut() {
    try {
      auth.signOut();
      // 로그아웃 성공 시 추가적인 로직 수행 가능
    } catch (e) {
      // 로그아웃 실패 시 에러 처리
      print(e.toString());
    }
  }

  void _setUserInfo(User? user) async {
    UserRepository.getUserData(number.text.trim())
        .then((value) => moveAfterLogin());
  }

  void moveAfterLogin() {
    SharedPreferences.getInstance().then((value) {
      final showHome = value.getBool('showHome') ?? false;
      if (showHome) {
        Get.off(() => const MainHome(), binding: AppBinding());
      } else {
        Get.off(() => const OnBoardingPage(), binding: OnboardBinding());
      }
    });
  }
}
