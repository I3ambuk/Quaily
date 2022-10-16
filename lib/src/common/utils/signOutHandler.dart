import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignOutHandler with ChangeNotifier {
  SignOutHandler._privateConstructor();

  static final SignOutHandler instance = SignOutHandler._privateConstructor();

  Future<void> signOut() async {
    //Notify all signOutListener to clear data
    notifyListeners();
    return FirebaseAuth.instance.signOut();
  }
}
