import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quaily/src/features/authentication/screens/signup.dart';
import 'package:quaily/src/features/posts/screens/home.dart';
import 'src/common/services/firebase/firebase_options.dart';
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
