import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:quaily/src/common/services/firebase/firebaseFunctions.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';

User? currentFirebaseUser;
DocumentReference<Map<String, dynamic>>? userDocRef;
//Listanable currentUser all Pages using it will lsten to it
QuailyUser? currentQuailyUser;

Future<void> initCurrentUser() async {
  currentFirebaseUser = FirebaseAuth.instance.currentUser!;

  //Initialisiere currentQuailyUser with data from firebase
  userDocRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentFirebaseUser!.uid);
  DocumentSnapshot<Map<String, dynamic>> snapshot = (await userDocRef!.get());
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
    currentQuailyUser = QuailyUser(displayName, userPhoneNumber, uid);
  }
}

void clear() {
  currentFirebaseUser = null;
  userDocRef = null;
  currentQuailyUser = null;
}
