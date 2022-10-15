import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quaily/src/common/services/firebase/firebaseFunctions.dart';

class QuailyUser with ChangeNotifier {
  QuailyUser(this.displayname, this.phone, this.uid) {
    updateAvatar();
    color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  String displayname, phone, uid;
  ImageProvider<Object> avatar = const AssetImage('assets/default_profile.png');
  Color color = Colors.white;

  Future<void> updateAvatar() async {
    avatar = await getPicFromUrl(uid: uid) ?? avatar;
    notifyListeners();
  }

  String initials() {
    return displayname.substring(0, 1);
  }
}
