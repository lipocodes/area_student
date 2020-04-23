import 'package:areastudent/tools/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:areastudent/data/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'signup.dart';
import 'profile.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:areastudent/tools/widgets.dart';

class Login extends StatelessWidget {
  MediaQueryData queryData;
  TextEditingController controllerPhoneNumber = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String verificationId = "";
  FirebaseMethods firebaseMethod = new FirebaseMethods();

  void validateUser(BuildContext context) async {
    String phoneNumber = controllerPhoneNumber.text;

    controllerPhoneNumber.text = "";
    if (phoneNumber.length == 0) {
      showSnackBar(screen3PhoneNumberEmpty, scaffoldKey);
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();

      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new Profile()));
    }
  }

  buttonLoginTapped(BuildContext context) async {
 

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        child: Text(
                          "X",
                          style:
                              new TextStyle(fontSize: 26.0, color: Colors.grey),
                        ),
                        onTap: () => Navigator.of(context).pop())
                  ],
                ),
                Text(
                  screen3Login,
                  style: new TextStyle(
                      fontSize: 26.0, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 20.0),
                Text(screen3WelcomeBack,
                    style: new TextStyle(fontSize: 22.0, color: Colors.grey)),
              ],
            ),
            content: new TextFormField(
              decoration: new InputDecoration(
                labelText: screen3PhoneNumberHint,
                fillColor: Colors.grey[100],
                filled: true,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                ),
              ),
              controller: controllerPhoneNumber,
              keyboardType: TextInputType.phone,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  RaisedButton(
                    //Login button
                    onPressed: () {
                      validateUser(context);
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
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
                      padding: const EdgeInsets.fromLTRB(100, 15, 100, 15),
                      child: const Text(screen3Login,
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  new SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: scaffoldKey,
        //column: all the widgets are to be shown verically
        body: new Column(
          children: [
            //container: show the welcome text above the background image
            new Container(
              child: new Stack(
                //we need the welcome text to be on top of the welcome image
                children: [
                  Container(
                      //welcome image
                      child: Padding(
                    padding: const EdgeInsets.only(left: 80.0, top: 80.0),
                    child: new Image.asset('assets/images/screen2.png'),
                  )),
                  Column(
                    //welcome title & welcome body
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 100.0),
                        child: new Text(
                          screen2WelcomeTitle,
                          style: new TextStyle(
                              fontSize: 26.0, fontWeight: FontWeight.w900),
                        ),
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 70.0,
                        ),
                        child: new Text(screen2WelcomeBody,
                            style: new TextStyle(
                                fontSize: 22.0, color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            new SizedBox(height: 25.0),

            //container: Signup & Login buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new CupertinoPageRoute(
                          builder: (BuildContext context) => new Signup()));
                    },
                    child: signupButton(whichScreen: 2)),
              ],
            ),

            new SizedBox(
              height: 20.0,
            ),

            //divider 'OR'
            Row(children: <Widget>[
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
              Text("OR"),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.black,
                      height: 36,
                    )),
              ),
            ]),

            //Login option for users who already have an account
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Text(
                    "Already Have an Account?",
                    style: new TextStyle(
                        fontWeight: FontWeight.w300, fontSize: 16.0),
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        buttonLoginTapped(context);
                      },
                      child: new Text(
                        "LOGIN",
                        style: new TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0,
                          color: Colors.lightBlue,
                          decoration: TextDecoration.underline,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
