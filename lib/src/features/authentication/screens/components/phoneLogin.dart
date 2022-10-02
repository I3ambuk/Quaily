import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quaily/src/features/posts/screens/home.dart';

class PhoneLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PhoneLoginState();
}

class PhoneLoginState extends State<PhoneLogin> {
  late TextEditingController phoneController;
  late TextEditingController otpController;
  late bool otpVisibility;
  late String verificationID;
  late User? user;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    otpController = TextEditingController();
    otpVisibility = false;
    verificationID = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Visibility(
              visible: !otpVisibility,
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+49'),
                  ),
                ),
                maxLength: 15,
                keyboardType: TextInputType.phone,
              ),
            ),
            Visibility(
              visible: otpVisibility,
              child: PinCodeTextField(
                controller: otpController,
                appContext: context,
                onChanged: (value) => {},
                onCompleted: (value) => verifyOtp(),
                length: 6,
                keyboardType: TextInputType.phone,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  if (otpVisibility) {
                    verifyOtp();
                  } else {
                    loginWithPhone();
                  }
                },
                child: const Text('Weiter'),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text('DEV-HOME'),
              ),
            )
          ],
        ));
  }

  void loginWithPhone() async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+49${phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          otpVisibility = true;
          verificationID = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOtp() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    await FirebaseAuth.instance.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          Fluttertoast.showToast(
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Home()));
        } else {
          Fluttertoast.showToast(
            msg: "your login is failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
    );
  }
}
