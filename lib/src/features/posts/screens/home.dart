import 'package:flutter/material.dart';
import 'package:quaily/src/features/authentication/screens/signup.dart';

import 'package:quaily/src/features/friends/screens/friends.dart';
import 'package:quaily/src/features/posts/screens/components/homePage.dart';
import 'package:quaily/src/features/settings/screens/profile.dart';
import 'package:quaily/src/features/settings/screens/settings.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          appBarTheme: ThemeData.dark()
              .appBarTheme
              .copyWith(backgroundColor: Color.fromARGB(255, 46, 71, 83))),
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/friends': (context) => Friends(),
        '/profile': (context) => Profile(),
        '/settings': (context) => Settings(),
        '/signup': (context) => SignUp(),
      },
    );
  }
}
