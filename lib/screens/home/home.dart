import 'package:flutter/material.dart';

import 'package:quaily/screens/friends/friends.dart';
import 'package:quaily/screens/home/components/homePage.dart';
import 'package:quaily/screens/profile/profile.dart';
import 'package:quaily/screens/settings/settings.dart';

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
      },
    );
  }
}
