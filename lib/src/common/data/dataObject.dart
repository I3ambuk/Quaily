import 'package:quaily/src/common/utils/signOutHandler.dart';

abstract class CurrentUserData {
  CurrentUserData() {
    SignOutHandler.instance.addListener(() {
      clearData();
    });
  }
  //should clear all user specific data
  //Is automaticly called when logout
  void clearData();
}
