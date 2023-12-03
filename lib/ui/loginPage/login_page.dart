import 'package:flutter/material.dart';
import 'package:flutter_main_page/src/components/input_field.dart';
import 'package:flutter_main_page/src/components/login_button.dart';
import 'package:flutter_main_page/src/controller/auth_controller.dart';
import 'package:flutter_main_page/ui/loginPage/create_user.dart';
import 'package:flutter_main_page/ui/loginPage/reset_pass.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _logo(),
                    SizedBox(
                      height: 10,
                    ),
                    _title(),
                    const SizedBox(height: 50),
                    _loginTextFields(),
                    SizedBox(
                      height: 20,
                    ),
                    _buttons(),
                    SizedBox(
                      height: 20,
                    ),
                    _bottom(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _logo() {
    return Container(
      width: 100,
      height: 100,
      child: Image.asset('assets/Images/app_logo.png'),
    );
  }

  Widget _title() {
    return Column(
      children: [
        Text(
          "인덕대학교",
          style: GoogleFonts.eastSeaDokdo(
            textStyle: TextStyle(
              fontSize: 60,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Text(
          "Information and Communication",
          style: TextStyle(
              fontSize: 20, fontFamily: 'Pacifico', color: Colors.black),
        ),
      ],
    );
  }

  Widget _loginTextFields() {
    return Column(
      children: [
        InputField(
          controller: controller.number,
          hintText: '학번을 입력하세요',
          prefixIcon: Icon(Icons.account_circle),
          obscure: false,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(
          height: 5,
        ),
        InputField(
            controller: controller.password,
            hintText: '비밀번호를 입력하세요.',
            prefixIcon: Icon(Icons.lock),
            obscure: true,
            keyboardType: TextInputType.text),
      ],
    );
  }

  Widget _buttons() {
    return Column(
      children: [
        LoginButton(
          onPressed: controller.checkUserInfo,
          child: (controller.loading)
              ? CircularProgressIndicator.adaptive()
              : Text(
                  "로그인",
                  style: TextStyle(
                      fontSize: 15, letterSpacing: 4.0, color: Colors.white),
                ),
        ),
        TextButton(
          //회원가입 버튼
          onPressed: () => Get.to(() => const CreateUserPage()),
          style: TextButton.styleFrom(),
          child: const Text(
            "회원가입",
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _bottom() {
    return Row(
      children: [
        const Text(
          "비밀번호를 잊으셨나요?",
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        TextButton(
          onPressed: () => Get.to(() => const ResetPassPage()),
          style: TextButton.styleFrom(),
          child: const Text(
            "Help",
            style: TextStyle(fontSize: 15, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
