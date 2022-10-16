import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quaily/src/common/data/dataObject.dart';
import 'package:quaily/src/common/data/userInformation.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

class FirebaseSocket extends CurrentUserData {
  FirebaseSocket._privateConstructor();
  static final FirebaseSocket instance = FirebaseSocket._privateConstructor();

  final _userCollection = FirebaseFirestore.instance.collection('users');
  QuailyUser? _currentUser = CurrentUserInfo.instance.currentQuailyUser;

  @override
  void clearData() {
    _currentUser = null;
  }

  Future<bool> sendFriendRequest(QuailyUser qu) async {
    bool res = false;
    if (_currentUser == null) return false;
    var friendUserReqIn =
        _userCollection.doc(qu.uid).collection('public').doc('requestsIn');
    var userReqOut = _userCollection
        .doc(_currentUser!.uid)
        .collection('public')
        .doc('requestsOut');

    //write currentUser in friendRequestIn from qu
    var userData = {
      _currentUser!.phone: jsonEncode(
          {'displayname': _currentUser!.displayname, 'uid': _currentUser!.uid})
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
    if (_currentUser != null) {
      var friendRequestsSnap = await _userCollection
          .doc(_currentUser!.uid)
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
    if (_currentUser != null) {
      var friendRequestsSnap = await _userCollection
          .doc(_currentUser!.uid)
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
    _userCollection.snapshots().listen((querySnapshot) {
      for (var diff in querySnapshot.docChanges) {
        if (diff.type == DocumentChangeType.added) {
          if (diff.doc.exists && diff.doc.data() != null) {
            Map<String, dynamic> userData = diff.doc.data()!;
            String userPhoneNumber = userData.containsKey('phoneNumber')
                ? diff.doc.get('phoneNumber')
                : 'NoPhone :(';
            String uid = diff.doc.data()!.containsKey('uid')
                ? diff.doc.get('uid')
                : null;
            String displayName = userData.containsKey('displayName')
                ? diff.doc.get('displayName')
                : 'NoDisplayName :(';
            ListUtils.instance
                .handleNewUser(QuailyUser(displayName, userPhoneNumber, uid));
          }
        }
        if (diff.type == DocumentChangeType.removed) {}
        if (diff.type == DocumentChangeType.modified) {}
      }
    });
  }
}
