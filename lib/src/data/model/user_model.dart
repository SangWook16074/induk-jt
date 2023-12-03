import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String userName;
  late String userNumber;
  late bool isAdmin;
  late String email;

  UserModel({
    required this.userName,
    required this.userNumber,
    required this.isAdmin,
    required this.email,
  });

  UserModel.fromJson({required DocumentSnapshot json}) {
    userName = json['userName'];
    userNumber = json['userNumber'];
    isAdmin = json['isAdmin'];
    email = json['email'];
  }

  UserModel.toJson({
    required String name,
    required String number,
    required String inputEmail,
  }) {
    userName = name;
    userNumber = number;
    isAdmin = false;
    email = inputEmail;
  }

  // UserModel.toDocumentSnapshot()
}
