import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quaily/src/common/services/firebase/firebaseFunctions.dart';

class QuailyUser with ChangeNotifier {
  QuailyUser(this.displayname, this.phone, this.uid) {
    //TODO: add Option to set avatar with url directly
    //if no url is passed execute updateAvatar()
    updateAvatar();
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  String displayname, phone, uid;
  ImageProvider<Object> avatar = const AssetImage('assets/default_profile.png');
  Color color = Colors.white;

  //TODO: getDownloadUrl (if pic exists),set avatar and store url in FirestoreDB
  Future<void> updateAvatar() async {
    avatar = await getPicFromUrl(uid: uid) ?? avatar;
    notifyListeners();
  }

  String initials() {
    return displayname.substring(0, 1);
  }
}
