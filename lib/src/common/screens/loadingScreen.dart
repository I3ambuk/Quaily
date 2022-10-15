import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quaily/src/common/data/userInformation.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingState();
}

class _LoadingState extends State<LoadingScreen> {
  //TODO: initialisiere daten bei appstart und frage nach Permissions
  @override
  void initState() {
    super.initState();
    init().then((value) => Navigator.pushReplacementNamed(context, '/home'));
  }

  Future<void> init() async {
    await initCurrentUser();
  }

  //TODO: Initialisiere Daten und frage nach Permissions
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
