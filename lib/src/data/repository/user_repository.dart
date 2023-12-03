import 'package:flutter_main_page/src/data/provider/user_provider.dart';

class UserRepository {
  static getUserData(String userNumber) =>
      UserProvider.getUserDataApi(userNumber);
}
