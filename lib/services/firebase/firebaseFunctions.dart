import 'dart:developer' as dev;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

var user = FirebaseAuth.instance.currentUser;
var profilePicUrl = ValueNotifier<String>(' ');

ImageProvider<Object> getProfilePic() {
  if (profilePicUrl.value != ' ') {
    dev.log(profilePicUrl.value);
    return Image.network(profilePicUrl.value).image;
  }
  return const AssetImage('assets/default_profile.png');
}

Future<void> fetchProfilePicUrl() async {
  var folderRef = FirebaseStorage.instance.ref('users/' + user!.uid + "/");
  var picRef = folderRef.child('profilepic.jpg');

  await folderRef.listAll().then((res) async {
    if (res.items.isNotEmpty) {
      await picRef.getDownloadURL().then((url) => profilePicUrl.value = url);
    }
  }).catchError((error) {
    profilePicUrl.value = ' ';
  });
}
