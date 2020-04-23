import 'package:areastudent/tools/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phoneNo = "";
  String smsCode="";
  bool codeSent = false;
  final formKey = new GlobalKey<FormState>();
  String verificationId = "";
  FirebaseMethods firebaseMethod = new FirebaseMethods();

  Future<void> verifyPhone(String phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      firebaseMethod.signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww= " + authException.message);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: new TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Please enter your phone number',
                ),
                onChanged: (val) {
                  setState(() {
                    this.phoneNo = val;
                  });
                },
              ),
            ),
           codeSent ?  new Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: new TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Please copy the code you have just got in the SMS',
                ),
                onChanged: (val) {
                  setState(() {
                    this.smsCode = val;
                  });
                },
              ),
            ): Container(),
            new Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: new RaisedButton(
                onPressed: () {
                  codeSent?  firebaseMethod.signInWithOTP(this.smsCode, this.verificationId) : verifyPhone(this.phoneNo);
                },
                child: new Center(
                  child: codeSent ? new Text("Login")  : new Text("Verify"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
