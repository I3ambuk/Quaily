import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');
/**
 * Add a User to Firebase Collection named 'users'
 * Firebase Rule is responsible for users only added once
 */
void addUser(User? user) {
  if (user != null) {
    var data = {
      'phoneNumber': user.phoneNumber,
      'uid': user.uid,
    };
    usersCollection.doc(user.uid).set(data);
  } else {
    print('Adding User failed');
  }
}
