import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quaily/screens/authentication/signup.dart';
import 'package:quaily/screens/home/home.dart';
import 'services/firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:quaily/screens/friends/friends.dart';
import 'package:quaily/screens/profile/profile.dart';
import 'package:quaily/screens/settings/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: FirebaseAuth.instance.currentUser,
      value: FirebaseAuth.instance.userChanges(),
      child: MaterialApp(
        home: FirebaseAuth.instance.currentUser != null ? Home() : SignUp(),
        theme: ThemeData.dark().copyWith(
            appBarTheme: ThemeData.dark()
                .appBarTheme
                .copyWith(backgroundColor: Color.fromARGB(255, 46, 71, 83))),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => Home(),
          '/signup': (BuildContext context) => SignUp(),
          '/friends': (BuildContext context) => Friends(),
          '/profile': (BuildContext context) => Profile(),
          '/settings': (BuildContext context) => Settings(),
        },
      ),
    );
  }
}



/**
 * MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Quaily'),
        ),
        body: Text('BODY TEXT'),
      ),
    );
  }
 */