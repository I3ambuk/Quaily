import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quaily/src/common/data/dataObject.dart';
import 'package:quaily/src/common/data/userInformation.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/customContact.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

//BUG: Testen Notwendig! Nach den sendRequest und add friend listen aktualisiern!
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
    if (_currentUser != null) {
      return await _setFriend(_currentUser!, qu, 'requested') &&
          await _setFriend(qu, _currentUser!, 'pending');
    }
    return false;
  }

  Future<bool> addFriend(QuailyUser qu) async {
    if (_currentUser != null) {
      return await _setFriend(_currentUser!, qu, 'accepted') &&
          await _setFriend(qu, _currentUser!, 'accepted');
    }
    return false;
  }

  Future<Map<String, QuailyUser>> getFriendrequestsIn() async {
    return _getFriendWithStatus('pending');
  }

  Future<Map<String, QuailyUser>> getFriendrequestsOut() async {
    return _getFriendWithStatus('requested');
  }

  Future<Map<String, QuailyUser>> getFriends() async {
    return _getFriendWithStatus('accepted');
  }

  Future<bool> removeFriend(QuailyUser qu) async {
    if (_currentUser != null) {
      return await _removeFriend(_currentUser!, qu) &&
          await _removeFriend(qu, _currentUser!);
    }
    return false;
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

  ///sets the $frienOfUser to the friendlist of $user in Firebase with the given status(pending, requested, accepted)
  Future<bool> _setFriend(
      QuailyUser user, QuailyUser friendOfUser, String status) async {
    var res = false;
    //Reference of friendlist of $user
    var friends =
        _userCollection.doc(user.uid).collection('public').doc('friends');
    //Data to write
    var data = {
      friendOfUser.phone: jsonEncode({
        'displayname': friendOfUser.displayname,
        'uid': friendOfUser.uid,
        'status': status,
      })
    };
    if (status == 'accepted') {
      //update existing friend and accept, accepting a non-existing friend is not possible
      await friends.update(data).onError((error, stackTrace) {
        print(
            'Schreiben von ${friendOfUser.uid}, als $status in Freundesliste von ${user.uid} fehlgeschlagen!');
      }).then((value) => res = true);
    } else if (status == 'pending' || status == 'requested') {
      //set non-existing friend
      await friends
          .set(data, SetOptions(merge: true))
          .onError((error, stackTrace) {
        print(
            'Schreiben von ${friendOfUser.uid}, als $status in Freundesliste von ${user.uid} fehlgeschlagen!');
      }).then((value) => res = true);
    }
    return res;
  }

  Future<bool> _removeFriend(QuailyUser user, QuailyUser friendToRemove) async {
    //Reference of friendlist of $user
    var friendsSnap = await _userCollection
        .doc(user.uid)
        .collection('public')
        .doc('friends')
        .get();
    var friends = friendsSnap.data() ?? <String, dynamic>{};

    return (friends.remove(friendToRemove.phone) != null);
  }

  Future<Map<String, QuailyUser>> _getFriendWithStatus(String status) async {
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
        String friendStatus =
            infos.containsKey('status') ? infos['status'] : '';
        if (friendStatus == status) {
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
}
