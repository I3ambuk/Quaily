import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quaily/src/common/data/dataObject.dart';
import 'package:quaily/src/common/data/userInformation.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

//TODO: Functionen zusammenfassen die ähnlich sind!! (die ganzen getter)
//TODO: nach den sendRequest und add frien listen aktualisiern!
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
    if (_currentUser != null) {
      var qufriends =
          _userCollection.doc(qu.uid).collection('public').doc('friends');

      var userfriends = _userCollection
          .doc(_currentUser!.uid)
          .collection('public')
          .doc('friends');

      //write currentUser in friends from qu with status pending
      var userData = {
        _currentUser!.phone: jsonEncode({
          'displayname': _currentUser!.displayname,
          'uid': _currentUser!.uid,
          'status': 'pending'
        })
      };
      await qufriends
          .set(userData, SetOptions(merge: true))
          .onError((error, stackTrace) {
        print('Schreiben in RequestIn fehlgeschlagen!');
      });

      //write qu in friends from user with status requested
      var friendData = {
        qu.phone: jsonEncode({
          'displayname': qu.displayname,
          'uid': qu.uid,
          'status': 'requested'
        })
      };
      await userfriends
          .set(friendData, SetOptions(merge: true))
          .onError((error, stackTrace) {
        print('Schreiben in RequestOut fehlgeschlagen!');
      }).then((value) => res = true);
    }
    return res;
  }

  Future<Map<String, QuailyUser>> getFriendrequestsIn() async {
    var map = <String, QuailyUser>{};
    if (_currentUser != null) {
      var friendsSnap = await _userCollection
          .doc(_currentUser!.uid)
          .collection('public')
          .doc('friends')
          .get();
      var friends = friendsSnap.data() ?? <String, dynamic>{};

      friends.forEach((key, value) {
        Map<String, dynamic> infos = jsonDecode(value.toString());
        //add to map if status is pending
        String status = infos.containsKey('status') ? infos['status'] : '';
        if (status == 'pending') {
          String displayname = infos.containsKey('displayname')
              ? infos['displayname']!
              : 'NoDisplayname';
          String uid = infos.containsKey('uid') ? infos['uid']! : 'NoUid';
          String phone = key;
          map.putIfAbsent(phone, () => QuailyUser(displayname, phone, uid));
        }
      });
    }
    return map;
  }

  Future<Map<String, QuailyUser>> getFriendrequestsOut() async {
    var map = <String, QuailyUser>{};
    if (_currentUser != null) {
      var friendsSnap = await _userCollection
          .doc(_currentUser!.uid)
          .collection('public')
          .doc('friends')
          .get();
      var friends = friendsSnap.data() ?? <String, dynamic>{};

      friends.forEach((key, value) {
        Map<String, dynamic> infos = jsonDecode(value.toString());
        //map if status is requested
        String status = infos.containsKey('status') ? infos['status'] : '';
        if (status == 'requested') {
          String displayname = infos.containsKey('displayname')
              ? infos['displayname']!
              : 'NoDisplayname';
          String uid = infos.containsKey('uid') ? infos['uid']! : 'NoUid';
          String phone = key;
          map.putIfAbsent(phone, () => QuailyUser(displayname, phone, uid));
        }
      });
    }
    return map;
  }

  Future<bool> addFriend(QuailyUser qu) async {
    bool res = false;

    if (_currentUser != null) {
      var quFriends =
          _userCollection.doc(qu.uid).collection('public').doc('friends');
      var userFriends = _userCollection
          .doc(_currentUser!.uid)
          .collection('public')
          .doc('friends');

      //update newFriends Firebase DB
      //write currentUser in friends from qu with status accepted
      var userData = {
        _currentUser!.phone: jsonEncode({
          'displayname': _currentUser!.displayname,
          'uid': _currentUser!.uid,
          'status': 'accepted'
        })
      };
      await quFriends.update(userData).onError((error, stackTrace) {
        print('UPDATE VON QU FRIENDS FEHLGESCHLAGEN!!');
        res = false;
      });
      //update own Firebase DB
      //write qu in friends from user with status accepted
      var friendData = {
        qu.phone: jsonEncode({
          'displayname': qu.displayname,
          'uid': qu.uid,
          'status': 'accepted'
        })
      };
      await userFriends.update(friendData).onError((error, stackTrace) {
        print('UPDATE VON USER FRIENDS FEHLGESCHLAGEN!!');
        res = false;
      });
    }
    return res;
  }

  bool declineFriendRequest(QuailyUser qu) {
    //TODO: implement decline FriendRequest
    return false;
  }

  bool removeFriend(String uid) {
    return false;
  }

  bool inviteContact(Contact c) {
    return false;
  }

  Future<Map<String, QuailyUser>> getFriends() async {
    var map = <String, QuailyUser>{};
    if (_currentUser != null) {
      var friendsSnap = await _userCollection
          .doc(_currentUser!.uid)
          .collection('public')
          .doc('friends')
          .get();
      var friends = friendsSnap.data() ?? <String, dynamic>{};

      friends.forEach((key, value) {
        Map<String, dynamic> infos = jsonDecode(value.toString());
        //map if status is requested
        String status = infos.containsKey('status') ? infos['status'] : '';
        if (status == 'accepted') {
          String displayname = infos.containsKey('displayname')
              ? infos['displayname']!
              : 'NoDisplayname';
          String uid = infos.containsKey('uid') ? infos['uid']! : 'NoUid';
          String phone = key;
          map.putIfAbsent(phone, () => QuailyUser(displayname, phone, uid));
        }
      });
    }
    return map;
  }

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
