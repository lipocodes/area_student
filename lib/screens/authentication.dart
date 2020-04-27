import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:areastudent/data/constants.dart';
import 'package:areastudent/tools/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'profile.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:country_code_picker/country_code_picker.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final formKey = new GlobalKey<FormState>();
  String phoneNo = "";
  static String verificationId;
  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  static BuildContext con;
  String countryCode="+972";

 void _onCountrySelected(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    this.countryCode = countryCode.toString();
  }

//called when the server creates a new authentication account successfully
  final PhoneVerificationCompleted verified = (AuthCredential authResult) {
    AuthService().signIn(authResult);
    Navigator.of(con).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new Profile()));
  };

//if new account creation on FB authntication  fails
  final PhoneVerificationFailed verificationFailed =
      (AuthException authException) {
    print("ddddddddddddddddddddddddddd= " + authException.message);
    Navigator.of(con).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new Profile()));
    //showSnackBar(screen8WrongNumber, scaffoldKey);
  };

//called once a SMS is sent to the user (though the user doesn't do anything with it)
  final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
    verificationId = verId;
  };

  final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
    verificationId = verId;
  };

  Future<void> verifyPhone() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (this.phoneNo.length > 0) {
      if(this.phoneNo.substring(0,1) == "0")   this.phoneNo = this.phoneNo.substring(1);

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: this.countryCode + this.phoneNo,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verified,
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout);
    }
  }

  @override
  Widget build(BuildContext context) {
    con = context;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: new Text(
          "",
        ),
        backgroundColor: Colors.white,
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 30.0),
            child: new Text(
              screen8TitleText,
              style: new TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: new Text(screen8TitleBody,
                style: new TextStyle(fontSize: 22.0, color: Colors.grey)),
          ),
          new SizedBox(height: 50.0),
          new Form(
            key: formKey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CountryCodePicker(
                  onChanged: _onCountrySelected,
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'IL',
                  favorite: ['+972', 'IL'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
                new Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: new TextFormField(
                    style: new TextStyle(
                      fontSize: 14.0,
                      fontFamily: "Poppins",
                      color: Colors.grey[600],
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: new InputDecoration(
                      hintText: screen8HintText,
                      fillColor: Colors.grey[100],
                      filled: true,
                      contentPadding: EdgeInsets.only(
                        top: 10.0,
                        left: 10.0,
                        bottom: 10.0,
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        this.phoneNo = val;
                      });
                    },
                  ),
                ),
                new SizedBox(height: 20.0),
                new Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: new RaisedButton(
                    onPressed:
                        verifyPhone, //the click event is impolemented in the screen classes
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFB3F5FC),
                              Color(0xFF81D4FA),
                              Color(0xFF29B6F6),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      padding: const EdgeInsets.fromLTRB(110, 12, 110, 12),
                      child: new Text(screen8AuthenticationButton,
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
