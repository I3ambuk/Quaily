import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quaily/screens/authentication/signup.dart';
import 'package:quaily/screens/home/home.dart';
import 'services/firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(StreamProvider<User?>.value(
    initialData: FirebaseAuth.instance.currentUser,
    value: FirebaseAuth.instance.userChanges(),
    child: MaterialApp(
      theme: ThemeData.dark().copyWith(
          appBarTheme: ThemeData.dark()
              .appBarTheme
              .copyWith(backgroundColor: Color.fromARGB(255, 46, 71, 83))),
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser != null ? '/home' : '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => SignUp(),
        '/home': (BuildContext context) => Home(),
      },
    ),
  ));
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