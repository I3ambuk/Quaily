import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

var userSnapshotStream =
    FirebaseFirestore.instance.collection('users').snapshots();

bool sendFriendRequest() {
  return false;
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

List<String> getFriends() {
  return [];
}

setUpUserListener() {
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
