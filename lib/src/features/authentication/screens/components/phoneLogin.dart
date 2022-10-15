import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quaily/src/features/entryPoint/screens/mainApp.dart';
import 'package:quaily/src/features/authentication/utils/phoneLogin.dart';

class PhoneLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PhoneLoginState();
}

class PhoneLoginState extends State<PhoneLogin> {
  late TextEditingController phoneController;
  late TextEditingController otpController;
  late bool otpVisibility;
  late String verificationID;

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
                onCompleted: (value) =>
                    verifyOtp(this, verificationID, otpController.text),
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
                    verifyOtp(this, verificationID, otpController.text);
                  } else {
                    loginWithPhone(this, '+49${phoneController.text}');
                  }
                },
                child: const Text('Weiter'),
              ),
            ),
          ],
        ));
  }

  void handleSuccessfulPhoneNumber(String verificationId) {
    setState(() {
      otpVisibility = true;
      this.verificationID = verificationId;
    });
  }

  void handleSuccessfulLogin() {
    Fluttertoast.showToast(
      msg: "You are logged in successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainApp()));
  }

  void handlefailedLogin() {
    Fluttertoast.showToast(
      msg: "Wrong code, please enter again",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    otpController.clear();
  }
}
