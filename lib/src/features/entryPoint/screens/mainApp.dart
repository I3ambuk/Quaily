import 'package:flutter/material.dart';
import 'package:quaily/src/features/entryPoint/screens/loadingScreen.dart';
import 'package:quaily/src/features/authentication/screens/signup.dart';

import 'package:quaily/src/features/friends/screens/friends.dart';
import 'package:quaily/src/features/posts/screens/homePage.dart';
import 'package:quaily/src/features/settings/screens/profile.dart';
import 'package:quaily/src/features/settings/screens/settings.dart';

//Einstiegspunkt nach Login
class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          appBarTheme: ThemeData.dark()
              .appBarTheme
              .copyWith(backgroundColor: Color.fromARGB(255, 46, 71, 83))),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => LoadingScreen(),
        '/home': (BuildContext context) => HomePage(),
        '/friends': (context) => Friends(),
        '/profile': (context) => Profile(),
        '/settings': (context) => Settings(),
        '/signup': (context) => SignUp(),
      },
    );
  }
}
