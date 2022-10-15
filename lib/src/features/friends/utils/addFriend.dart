import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';

var userCollection = FirebaseFirestore.instance.collection('users');
var currentUser = FirebaseAuth.instance.currentUser;

Future<void> addContactAsFriend(QuailyUser c) async {
  //TODO: Entferne User aus Listen in contactListUtils
  //TODO: ACHTUNG! SecurityRules geändert
  if (currentUser == null) return;
  var friendUserDoc = userCollection.doc(c.uid);
  var userDoc = userCollection.doc(currentUser!.uid);

  friendUserDoc.update(
    {
      "requestsIn": FieldValue.arrayUnion([currentUser!.uid]),
    },
  ).onError((error, stackTrace) => print('Update UserDoc failed :$error'));

  userDoc.update(
    {
      "requestsOut": FieldValue.arrayUnion([c.uid]),
    },
  ).onError((error, stackTrace) => print('Update UserDoc failed :$error'));
}

void inviteContact(Contact c) {
  //TODO: Freund einladen funktionalität
  print(c.givenName);
}
