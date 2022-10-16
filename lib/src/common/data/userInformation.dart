import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quaily/src/common/data/dataObject.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';

class CurrentUserInfo extends CurrentUserData {
  CurrentUserInfo._privateConstructor();
  static final CurrentUserInfo instance = CurrentUserInfo._privateConstructor();

  User? _currentFirebaseUser;
  DocumentReference<Map<String, dynamic>>? _userDocRef;
  //Listanable currentUser all Pages using it will listen to it
  QuailyUser? _currentQuailyUser;

  @override
  void clearData() {
    _currentFirebaseUser = null;
    _userDocRef = null;
    _currentQuailyUser = null;
  }

  QuailyUser? get currentQuailyUser => _currentQuailyUser;

  Future<bool> initCurrentUserInfo() async {
    if (FirebaseAuth.instance.currentUser != null) {
      _currentFirebaseUser = FirebaseAuth.instance.currentUser;

      //Initialisiere currentQuailyUser with data from firebase
      _userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentFirebaseUser!.uid);
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          (await _userDocRef!.get());
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> userData = snapshot.data()!;

        String userPhoneNumber = userData.containsKey('phoneNumber')
            ? snapshot.get('phoneNumber')
            : 'NoPhone :(';
        String uid =
            snapshot.data()!.containsKey('uid') ? snapshot.get('uid') : null;
        String displayName = userData.containsKey('displayName')
            ? snapshot.get('displayName')
            : 'NoDisplayName :(';
        //[ ] get ProfileUrl here and set avater with Imagenetwork directly (if exists)
        //if not slow way implemented in QuailyUser
        _currentQuailyUser = QuailyUser(displayName, userPhoneNumber, uid);
        return true;
      }
    }
    return false;
  }
}
