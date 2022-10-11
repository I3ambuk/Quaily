import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'components/signUpAppBar.dart';
import 'components/phoneLogin.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: SignUpAppBar(),
      ),
      body: PhoneLogin(),
    );
  }
}
