import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quaily/src/common/data/userInformation.dart' as userinfo;
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

var userCollection = FirebaseFirestore.instance.collection('users');

Future<bool> sendFriendRequest(QuailyUser qu) async {
  bool res = false;
  if (userinfo.currentQuailyUser == null) return false;
  var friendUserReqIn =
      userCollection.doc(qu.uid).collection('public').doc('requestsIn');
  var userReqOut = userCollection
      .doc(userinfo.currentQuailyUser!.uid)
      .collection('public')
      .doc('requestsOut');

  //write currentUser in friendRequestIn from qu
  var userData = {
    userinfo.currentQuailyUser!.phone: jsonEncode({
      'displayname': userinfo.currentQuailyUser!.displayname,
      'uid': userinfo.currentQuailyUser!.uid
    })
  };
  await friendUserReqIn
      .set(userData, SetOptions(merge: true))
      .onError((error, stackTrace) {
    print('Schreiben in RequestIn fehlgeschlagen!');
  });

  //write qu in friendRequestOut from user
  var friendData = {
    qu.phone: jsonEncode({'displayname': qu.displayname, 'uid': qu.uid})
  };
  await userReqOut
      .set(friendData, SetOptions(merge: true))
      .onError((error, stackTrace) {
    print('Schreiben in RequestOut fehlgeschlagen!');
  }).then((value) => res = true);

  return res;
}

Future<Map<String, QuailyUser>> getFriendrequestsIn() async {
  var map = <String, QuailyUser>{};
  if (userinfo.currentQuailyUser != null) {
    var friendRequestsSnap = await userCollection
        .doc(userinfo.currentQuailyUser!.uid)
        .collection('public')
        .doc('requestsIn')
        .get();
    var friendRequests = friendRequestsSnap.data() ?? <String, dynamic>{};

    friendRequests.forEach((key, value) {
      Map<String, dynamic> infos = jsonDecode(value.toString());
      String displayname = infos.containsKey('displayname')
          ? infos['displayname']!
          : 'NoDisplayname';
      String uid = infos.containsKey('uid') ? infos['uid']! : 'NoUid';
      String phone = key;
      map.putIfAbsent(phone, () => QuailyUser(displayname, phone, uid));
    });
  }
  return map;
}

Future<Map<String, QuailyUser>> getFriendrequestsOut() async {
  var map = <String, QuailyUser>{};
  if (userinfo.currentQuailyUser != null) {
    var friendRequestsSnap = await userCollection
        .doc(userinfo.currentQuailyUser!.uid)
        .collection('public')
        .doc('requestsOut')
        .get();
    var friendRequests = friendRequestsSnap.data() ?? <String, dynamic>{};

    friendRequests.forEach((key, value) {
      Map<String, dynamic> infos = jsonDecode(value.toString());
      String displayname = infos.containsKey('displayname')
          ? infos['displayname']!
          : 'NoDisplayname';
      String uid = infos.containsKey('uid') ? infos['uid']! : 'NoUid';
      String phone = key;
      map.putIfAbsent(phone, () => QuailyUser(displayname, phone, uid));
    });
  }
  return map;
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

// Future<Map<String, QuailyUser>> getFriends() {
//   return [];
// }

void setUpUserListener() {
  userCollection.snapshots().listen((querySnapshot) {
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
