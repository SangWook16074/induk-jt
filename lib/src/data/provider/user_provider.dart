import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_main_page/src/data/model/user_model.dart';

class UserProvider {
  static Future<UserModel?> getUserDataApi(String userNumber) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('UserInfo')
          .where('userNumber', isEqualTo: userNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDocument = querySnapshot.docs.first;
        return UserModel.fromJson(json: userDocument);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
