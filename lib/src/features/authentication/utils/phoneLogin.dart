import 'package:firebase_auth/firebase_auth.dart';

import 'package:quaily/src/features/authentication/screens/components/phoneLogin.dart';

void loginWithPhone(PhoneLoginState state, String phoneNumber) async {
  FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    verificationCompleted: (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      print(e.message.toString());
    },
    codeSent: (String verificationId, int? resendToken) {
      state.handleSuccessfulPhoneNumber(verificationId);
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

void verifyOtp(
    PhoneLoginState state, String verificationID, String smsCode) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID, smsCode: smsCode);

  try {
    await FirebaseAuth.instance.signInWithCredential(credential).then(
      (value) {
        //User is successfully signed in, can set user to Firebaseauth.instance.currentUser
      },
    ).whenComplete(
      () {
        if (FirebaseAuth.instance.currentUser != null) {
          state.handleSuccessfulLogin();
        } else {
          state.handlefailedLogin();
        }
      },
    );
  } on FirebaseAuthException catch (e) {
    state.handlefailedLogin();
  }
}
