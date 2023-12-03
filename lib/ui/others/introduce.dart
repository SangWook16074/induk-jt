import 'package:flutter/material.dart';
import 'package:flutter_main_page/src/constants/image_path.dart';
import 'package:flutter_main_page/src/controller/onboard_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../src/components/onboard_page.dart';

class OnBoardingPage extends GetView<OnboardController> {
  const OnBoardingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: controller.page,
          onPageChanged: controller.pageChanged,
          children: [
            OnboardPage(
                type: Type.FIRST,
                imgPath: ImagePath.firstPage,
                title: '환영합니다!',
                subtitle: '인덕정통에 가입하신것을 진심으로 환영합니다.'),
            OnboardPage(
                imgPath: ImagePath.secondPage,
                title: '학생회 이벤트',
                subtitle: '총학생회와 정보통신공학과 학생회가 진행하는 다양한 이벤트를 한눈에 볼 수 있습니다.'),
            OnboardPage(
                imgPath: ImagePath.thirdPage,
                title: '간단한 소통',
                subtitle: '익명게시판을 통해 모르는 정보를 묻고, 친구들과 다양한 생각과 아이디어를 공유해보세요.'),
            OnboardPage(
                imgPath: ImagePath.fourthPage,
                title: '간단한 이동',
                subtitle: '메인페이지 아이콘을 클릭하면 교내 서비스가 있는 다양한 페이지로 이동할 수 있습니다!'),
            OnboardPage(
                imgPath: ImagePath.fifthPage,
                title: '발전을 위해',
                subtitle: '더 개선되고 다양한 서비스를 위해서 학생여러분들의 다양한 의견을 꼭 남겨주세요!'),
          ],
        ),
        bottomNavigationBar: Obx(() => Container(
            height: 80,
            padding: EdgeInsets.only(top: 8.0),
            child: (controller.isLast == true) ? _start() : _progress())));
  }

  Widget _start() {
    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueGrey,
          minimumSize: Size.fromHeight(80),
        ),
        onPressed: controller.start,
        child: Text(
          '시작하기',
          style: GoogleFonts.doHyeon(textStyle: TextStyle(fontSize: 30)),
        ));
  }

  Widget _progress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(onPressed: controller.skip, child: Text('SKIP')),
        Center(
            child: SmoothPageIndicator(
          controller: controller.page,
          count: 5,
          effect: WormEffect(
              spacing: 16,
              dotColor: Colors.grey,
              activeDotColor: Colors.blueGrey),
          onDotClicked: controller.dotClick,
        )),
        TextButton(onPressed: controller.next, child: Text('NEXT'))
      ],
    );
  }
}
