import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quaily/src/common/data/userInformation.dart' as userInfo;
import 'package:quaily/src/common/services/firebase/firebaseFunctions.dart';
import 'package:quaily/src/common/utils/quailyUser.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //TODO: anzeigen folgender Informationen: pb, Anzeigename, echtername...
  //TODO: Extra Button und Seite für Bearbeiten des Profils

  static const String _title = 'Profile';

  var user = FirebaseAuth.instance.currentUser;
  var pb = userInfo.currentQuailyUser!.avatar; //currenQuailyUser = null?

  Future<void> pickImage() async {
    if (await Permission.storage.request().isGranted) {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        return pickUploadImage(File(image.path));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userInfo.currentQuailyUser!.addListener(() {
      setState(() {
        pb = userInfo.currentQuailyUser!.avatar;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
              ),
            ),
            const Text(_title),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Ink.image(
                image: pb,
                fit: BoxFit.contain,
                child: InkWell(
                  onTap: () => pickImage(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
