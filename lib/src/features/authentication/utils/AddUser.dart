import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

//TODO: Make sure, user is only added once

FutureOr<void> addUser(User? user) {
  if (user != null) {
    var data = {
      'phoneNumber': user.phoneNumber,
      'uid': user.uid,
    };
    return usersCollection.add(data);
  } else {
    print('Adding User failed');
  }
  return null;
}
