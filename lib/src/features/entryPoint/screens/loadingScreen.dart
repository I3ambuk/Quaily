import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quaily/src/common/data/userInformation.dart';
import 'package:quaily/src/common/utils/permissionHandler.dart';
import 'package:quaily/src/features/friends/utils/listUtils.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingState();
}

class _LoadingState extends State<LoadingScreen> {
  bool contactPermission = false;

  @override
  void initState() {
    super.initState();
    init().then((value) => Navigator.pushReplacementNamed(context, '/home'));
  }

  Future<void> init() async {
    //Init Data everyone uses
    if (!await CurrentUserInfo.instance.initCurrentUserInfo()) {
      //initialisieren Fehlgeschlagen, Error und zurück zu SignUp
      print('Initialisieren der Daten fehlgeschlagen!');
    }

    //Init Data for friendfeature
    await _askPermissions();
    if (contactPermission) {
      await ListUtils.instance.initContacts();
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      const snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      const snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      setState(() => contactPermission = true);
    } else {
      _handleInvalidPermissions(permissionStatus);
      setState(() => contactPermission = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'QUAILY',
          style: GoogleFonts.specialElite(fontSize: 30.0),
        ),
      ),
    );
  }
}
