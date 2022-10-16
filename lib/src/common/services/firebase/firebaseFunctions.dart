import 'dart:developer' as dev;
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quaily/src/common/data/userInformation.dart';

var user = FirebaseAuth.instance.currentUser;

/// !Attention! Could be a problem if a lot of users fetch their and other profilpics too often, better use url and stream then
/// fetch ProfilePic from Firebase
/// if no uid is used, current User uid is used as default
Future<Uint8List> getProfilePicUint8List({String? uid}) async {
  String path = 'users/${uid ?? user!.uid}/';

  Reference folderRef = FirebaseStorage.instance.ref(path);
  Reference picRef = folderRef.child('profilepic.jpg');
  await folderRef.listAll().then((res) async {
    if (res.items.isNotEmpty) {
      return res.items.first.getData(
          2000000); //maxSize for Profilepic is 2MB TODO:error bei überschreitung?
    }
  }).catchError((error) {
    print('Profilbild nicht gefunden!');
  });
  return (await rootBundle.load('assets/default_profile.png'))
      .buffer
      .asUint8List();
}

Future<String?> _getProfilePicUrl(String path) async {
  String? result;
  Reference folderRef = FirebaseStorage.instance.ref(path);
  Reference picRef = folderRef.child('profilepic.jpg');
  await folderRef.listAll().then((res) async {
    if (res.items.isNotEmpty) {
      result = await picRef
          .getDownloadURL(); //TODO:speichere URL in FirestoreDatabase und erstelle nur bei nichtvorhanden sein.
    }
  }).catchError((error) {
    print('Profilbild nicht gefunden!');
  });
  return result;
}

Future<ImageProvider<Object>?> getPicFromUrl({String? uid}) async {
  String path = 'users/${uid ?? user!.uid}/';
  String? url = await _getProfilePicUrl(path);
  if (url != null) {
    return Image.network(url).image;
  }
  return null;
}

Future<void> pickUploadImage(File file) async {
  Reference ref = FirebaseStorage.instance
      .ref('users/${user!.uid}/')
      .child('profilepic.jpg');
  //update file in Firebase
  await ref.putFile(file);
  //update QuailyUserAvatar
  currentQuailyUser!.updateAvatar();
}
