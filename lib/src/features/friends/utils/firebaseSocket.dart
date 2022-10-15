import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

var userCollection = FirebaseFirestore.instance.collection('users');
var userSnapshotStream = userCollection.snapshots();
var currentUser = FirebaseAuth.instance.currentUser;

Future<bool> sendFriendRequest(QuailyUser qu) async {
  bool res = false;
  if (currentUser == null) return false;
  var friendUserReqIn =
      userCollection.doc(qu.uid).collection('public').doc('requestsIn');
  var userReqOut = userCollection
      .doc(currentUser!.uid)
      .collection('public')
      .doc('requestsOut');

  //write currentUser in friendRequestIn from qu
  await friendUserReqIn.set({currentUser!.uid: currentUser!.uid},
      SetOptions(merge: true)).onError((error, stackTrace) {
    print('Schreiben in RequestIn fehlgeschlagen!');
  });
  //write qu in friendRequestOut from user
  await userReqOut.set({qu.uid: qu.uid}, SetOptions(merge: true)).onError(
      (error, stackTrace) {
    print('Schreiben in RequestOut fehlgeschlagen!');
  }).then((value) => res = true);

  return res;
}

List<String> getFriendrequests() {
  return [];
}

bool addFriend(String uid) {
  return false;
}

bool removeFriend(String uid) {
  return false;
}

bool inviteContact(Contact c) {
  return false;
}

List<String> getFriends() {
  return [];
}

void setUpUserListener() {
  userSnapshotStream.listen((querySnapshot) {
    for (var diff in querySnapshot.docChanges) {
      if (diff.type == DocumentChangeType.added) {
        if (diff.doc.exists && diff.doc.data() != null) {
          Map<String, dynamic> userData = diff.doc.data()!;
          String userPhoneNumber = userData.containsKey('phoneNumber')
              ? diff.doc.get('phoneNumber')
              : 'NoPhone :(';
          String uid =
              diff.doc.data()!.containsKey('uid') ? diff.doc.get('uid') : null;
          String displayName = userData.containsKey('displayName')
              ? diff.doc.get('displayName')
              : 'NoDisplayName :(';
          handleNewUser(QuailyUser(displayName, userPhoneNumber, uid));
        }
      }
      if (diff.type == DocumentChangeType.removed) {}
      if (diff.type == DocumentChangeType.modified) {}
    }
  });
}
