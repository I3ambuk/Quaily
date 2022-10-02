import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:quaily/src/common/services/firebase/firebaseFunctions.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const String _title = 'Profile';

  var user = FirebaseAuth.instance.currentUser;

  void pickUploadImage() async {
    if (await Permission.storage.request().isGranted) {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      Reference ref = FirebaseStorage.instance
          .ref('users/' + user!.uid + "/")
          .child('profilepic.jpg');
      if (image != null) {
        await ref.putFile(File(image.path));
        fetchProfilePicUrl();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfilePicUrl();
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
              child: ValueListenableBuilder<String>(
                valueListenable: profilePicUrl,
                builder: (context, value, child) => Ink.image(
                  image: getProfilePic(),
                  fit: BoxFit.contain,
                  child: InkWell(
                    onTap: () => pickUploadImage(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
