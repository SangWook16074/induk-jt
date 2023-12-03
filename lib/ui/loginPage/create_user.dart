// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:google_fonts/google_fonts.dart';

// import '../database_sub/user_info.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _subStyle = TextStyle(fontSize: 17, color: Colors.black);
  var _userName;
  var _userNumber;
  var _userPass;
  var _userPassAgain;
  var _authCode;
  var _email;

  var isChecked = false;

  int currentStep = 0;

  void _showAuthDialog() {
    (Platform.isAndroid)
        ? showDialog(
            context: _scaffoldKey.currentContext!,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Text(
                    '입력한 이메일 주소로 인증확인 메일이 발송되었습니다. 인증을 완료해야 로그인할 수 있습니다.\n입력한 이메일 : ${_email.text}'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        clearController();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("확인")),
                ],
              );
            })
        : showCupertinoDialog(
            context: _scaffoldKey.currentContext!,
            barrierDismissible: false,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text(
                    '입력한 이메일 주소로 인증확인 메일이 발송되었습니다. 인증을 완료해야 로그인할 수 있습니다.\n입력한 이메일 : ${_email.text}'),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        clearController();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("확인")),
                ],
              );
            });
  }

  @override
  void initState() {
    _userName = TextEditingController();
    _userNumber = TextEditingController();
    _userPass = TextEditingController();
    _userPassAgain = TextEditingController();
    _authCode = TextEditingController();
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _userName.dispose();
    _userNumber.dispose();
    _userPass.dispose();
    _userPassAgain.dispose();
    _authCode.dispose();
    _email.dispose();
    super.dispose();
  }

  void clearController() {
    _userName.clear();
    _userNumber.clear();
    _userPass.clear();
    _userPassAgain.clear();
    _authCode.clear();
    _email.clear();
  }

  _onNext() {
    if (currentStep == 0) {
      if (_userName.text.isEmpty) {
        toastMessage("이름을 입력하세요.");
        return;
      }
      if (_userNumber.text.isEmpty) {
        toastMessage("학번을 입력하세요.");
        return;
      }

      setState(() {
        currentStep++;
      });

      return;
    }
    if (currentStep == 1) {
      if (_userPass.text.isEmpty) {
        toastMessage("비밀번호를 입력하세요.");
        return;
      }
      if (_userPassAgain.text.isEmpty) {
        toastMessage("비밀번호 확인을 입력하세요.");
        return;
      }

      if (_userPass.text != _userPassAgain.text) {
        toastMessage("비밀번호가 서로 다릅니다.");
        return;
      }

      setState(() {
        currentStep++;
      });

      return;
    }
  }

  _onCancel() {
    if (currentStep == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          child: Image.asset('assets/Images/app_logo.png'),
                        ),
                        Text(
                          "계정생성",
                          style: GoogleFonts.doHyeon(
                            textStyle: mainStyle,
                          ),
                        )
                      ],
                    ),
                    Stepper(
                      controlsBuilder: (context, _) {
                        if (currentStep != 2) {
                          return Row(
                            children: [
                              (Platform.isAndroid)
                                  ? SizedBox(
                                      child: ElevatedButton(
                                          onPressed: _onNext,
                                          child: Text('다음')),
                                    )
                                  : SizedBox(
                                      height: 40,
                                      child: CupertinoButton.filled(
                                          padding: EdgeInsets.all(0.0),
                                          minSize: 80.0,
                                          onPressed: _onNext,
                                          child: Text('다음')),
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              (Platform.isAndroid)
                                  ? SizedBox(
                                      child: ElevatedButton(
                                        onPressed: _onCancel,
                                        child: Text(
                                          '취소',
                                          style:
                                              TextStyle(color: Colors.blueGrey),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 40,
                                      child: CupertinoButton(
                                        minSize: 80.0,
                                        padding: EdgeInsets.all(0.0),
                                        onPressed: _onCancel,
                                        child: Text(
                                          '취소',
                                          style:
                                              TextStyle(color: Colors.blueGrey),
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                            ],
                          );
                        }

                        return (isChecked == true)
                            ? Row(
                                children: [
                                  (Platform.isAndroid)
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            bool isAdmin = false;
                                            if (_userName.text.isEmpty) {
                                              toastMessage("이름을 입력하세요.");
                                              return;
                                            }
                                            if (_userNumber.text.isEmpty) {
                                              toastMessage("학번을 입력하세요.");
                                              return;
                                            }
                                            if (_email.text.isEmpty) {
                                              toastMessage("이메일을 입력하세요.");
                                              return;
                                            }
                                            if (_userPass.text.isEmpty) {
                                              toastMessage("비밀번호를 입력하세요.");
                                              return;
                                            }
                                            if (_userPassAgain.text.isEmpty) {
                                              toastMessage("비밀번호를 확인해야합니다.");
                                              return;
                                            }
                                            if (_userPass.text !=
                                                _userPassAgain.text) {
                                              toastMessage("비밀번호 확인이 안됩니다.");
                                              return;
                                            }
                                            if (_authCode.text != "160") {
                                              toastMessage("학과 번호가 틀렸습니다.");
                                              return;
                                            }

                                            try {
                                              DocumentSnapshot userinfoData =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('UserInfo')
                                                      .doc(_userNumber.text)
                                                      .get();
                                              if (userinfoData.exists) {
                                                toastMessage(
                                                    "이미 존재하는 학번이 있습니다.");
                                                return;
                                              }

                                              await _auth
                                                  .createUserWithEmailAndPassword(
                                                      email: _email.text,
                                                      password: _userPass.text)
                                                  .then((value) {
                                                if (value.user!.email == null) {
                                                } else {
                                                  firestore
                                                      .collection('UserInfo')
                                                      .doc(_userNumber.text)
                                                      .set({
                                                    'userName': _userName.text,
                                                    'userNumber':
                                                        _userNumber.text,
                                                    'email': _email.text,
                                                    'isAdmin': isAdmin,
                                                  });
                                                }
                                                return value;
                                              });
                                              _showAuthDialog();

                                              FirebaseAuth.instance.currentUser
                                                  ?.sendEmailVerification();
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'weak-password') {
                                                toastMessage(
                                                    '비밀번호가 약합니다\n(추천)숫자 + 영어 + 특수문자');
                                                return;
                                              }
                                              if (e.code ==
                                                  'email-already-in-use') {
                                                toastMessage('이미 사용된 이메일입니다.');
                                                return;
                                              }
                                              toastMessage("잠시후에 다시 시도해주세요.");
                                            }
                                          },
                                          child: Text('완료'),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                        )
                                      : CupertinoButton(
                                          onPressed: () async {
                                            bool isAdmin = false;
                                            if (_userName.text.isEmpty) {
                                              toastMessage("이름을 입력하세요.");
                                              return;
                                            }
                                            if (_userNumber.text.isEmpty) {
                                              toastMessage("학번을 입력하세요.");
                                              return;
                                            }
                                            if (_email.text.isEmpty) {
                                              toastMessage("이메일을 입력하세요.");
                                              return;
                                            }
                                            if (_userPass.text.isEmpty) {
                                              toastMessage("비밀번호를 입력하세요.");
                                              return;
                                            }
                                            if (_userPassAgain.text.isEmpty) {
                                              toastMessage("비밀번호를 확인해야합니다.");
                                              return;
                                            }
                                            if (_userPass.text !=
                                                _userPassAgain.text) {
                                              toastMessage("비밀번호 확인이 안됩니다.");
                                              return;
                                            }
                                            if (_authCode.text != "160") {
                                              toastMessage("학과 번호가 틀렸습니다.");
                                              return;
                                            }

                                            try {
                                              DocumentSnapshot userinfoData =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('UserInfo')
                                                      .doc(_userNumber.text)
                                                      .get();
                                              if (userinfoData.exists) {
                                                toastMessage(
                                                    "이미 존재하는 학번이 있습니다.");
                                                return;
                                              }

                                              await _auth
                                                  .createUserWithEmailAndPassword(
                                                      email: _email.text,
                                                      password: _userPass.text)
                                                  .then((value) {
                                                if (value.user!.email == null) {
                                                } else {
                                                  firestore
                                                      .collection('UserInfo')
                                                      .doc(_userNumber.text)
                                                      .set({
                                                    'userName': _userName.text,
                                                    'userNumber':
                                                        _userNumber.text,
                                                    'email': _email.text,
                                                    'isAdmin': isAdmin,
                                                  });
                                                }
                                                return value;
                                              });
                                              _showAuthDialog();

                                              FirebaseAuth.instance.currentUser
                                                  ?.sendEmailVerification();
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'weak-password') {
                                                toastMessage(
                                                    '비밀번호가 약합니다\n(추천)숫자 + 영어 + 특수문자');
                                                return;
                                              }
                                              if (e.code ==
                                                  'email-already-in-use') {
                                                toastMessage('이미 사용된 이메일입니다.');
                                                return;
                                              }
                                              toastMessage("잠시후에 다시 시도해주세요.");
                                            }
                                          },
                                          child: Text('완료'),
                                          color: Colors.blueGrey,
                                        ),
                                ],
                              )
                            : Container();
                      },
                      onStepTapped: (index) {
                        setState(() {
                          currentStep = index;
                        });
                      },
                      steps: [
                        Step(
                            isActive: currentStep >= 0,
                            title: Text(
                              "회원 정보",
                              style: GoogleFonts.doHyeon(
                                textStyle: _subStyle,
                              ),
                            ),
                            content: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: _userName,
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      hintText: "이름 ex.홍길동",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                      suffixIcon: GestureDetector(
                                        child: const Icon(
                                          Icons.clear,
                                          color: Colors.blueGrey,
                                          size: 20,
                                        ),
                                        onTap: () => _userName.clear(),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: _userNumber,
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      hintText: "학번 ex.2022XXXXX",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                      suffixIcon: GestureDetector(
                                        child: const Icon(
                                          Icons.clear,
                                          color: Colors.blueGrey,
                                          size: 20,
                                        ),
                                        onTap: () => _userNumber.clear(),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _email,
                                  onChanged: (text) {
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      hintText: "E-mail",
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueGrey,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0))),
                                      suffixIcon: GestureDetector(
                                        child: const Icon(
                                          Icons.clear,
                                          color: Colors.blueGrey,
                                          size: 20,
                                        ),
                                        onTap: () => _userPassAgain.clear(),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            )),
                        Step(
                          isActive: currentStep >= 1,
                          title: Text(
                            "비밀번호",
                            style: GoogleFonts.doHyeon(
                              textStyle: _subStyle,
                            ),
                          ),
                          content: Column(
                            children: [
                              const Text(
                                "영어 + 숫자 + 특수문자",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: _userPass,
                                obscureText: true,
                                onChanged: (text) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    hintText: "비밀번호",
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))),
                                    suffixIcon: GestureDetector(
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.blueGrey,
                                        size: 20,
                                      ),
                                      onTap: () => _userPass.clear(),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                controller: _userPassAgain,
                                obscureText: true,
                                onChanged: (text) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    hintText: "비밀번호 확인",
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))),
                                    suffixIcon: GestureDetector(
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.blueGrey,
                                        size: 20,
                                      ),
                                      onTap: () => _userPassAgain.clear(),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        Step(
                          isActive: currentStep >= 2,
                          title: Text(
                            "인증",
                            style: GoogleFonts.doHyeon(
                              textStyle: _subStyle,
                            ),
                          ),
                          content: Column(
                            children: [
                              const Text(
                                "정보통신공학과 인증코드 입력",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: _authCode,
                                obscureText: true,
                                onChanged: (text) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    hintText: "학과 번호 ex.000",
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0))),
                                    suffixIcon: GestureDetector(
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.blueGrey,
                                        size: 20,
                                      ),
                                      onTap: () => _userPassAgain.clear(),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: isChecked,
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      onChanged: (value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      }),
                                  const Text(
                                    "개인정보 수집에 동의합니다.",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )
                                ],
                              ),
                              Text(
                                  '수집된 개인정보는 앱 화면 디스플레이, 회원이 관리자인지 확인하는 용도 외에는 사용되지 않습니다.(단, 비방성, 욕설 글을 작성한 사용자의 정보는 요청에 따라서 제 3자에게 제공될 수 있음)')
                            ],
                          ),
                        )
                      ],
                      currentStep: currentStep,
                    ),
                  ],
                )),
          ),
        ));
  }
}
