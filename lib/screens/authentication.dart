import 'package:areastudent/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:areastudent/data/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:areastudent/tools/methods.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String insertedCode = "";
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int numberOfInsertedDigits = 0;
  int numberOfWrongVerifications = 0;
  TextEditingController controllerVerificationController =
      new TextEditingController();

  Future<void> verifyInsertedCode(BuildContext context) async {
   /* if (numberOfInsertedDigits < 6) {
      FocusScope.of(context).requestFocus(FocusNode());
      showSnackBar(screen8NotSufficientDigits, scaffoldKey);
      return;
    } else if (numberOfWrongVerifications < 3) {
      displayProgressDialog(context);

      //send the user a SMS with a code
      bool isAuthCodeCorrect = false;
      


      if (res == false) {
        numberOfWrongVerifications++;
        closeProgressDialog(context);
        showSnackBar(screen8AuthenticationFailed, scaffoldKey);
        insertedCode = "";
        controllerVerificationController.text = "";
      }
    } else {
      showSnackBar(screen8TooMuchMistakes, scaffoldKey);
    }*/
  }

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: PinCodeTextField(
              length: 6,
              obsecureText: false,
              animationType: AnimationType.fade,
              shape: PinCodeFieldShape.box,
              animationDuration: Duration(milliseconds: 600),
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              textInputType: TextInputType.number,
              activeColor: Colors.blueAccent,
              inactiveColor: Colors.grey,
              backgroundColor: Colors.transparent,
              autoFocus: true,
              controller: controllerVerificationController,
              onCompleted: (v) {
                print("Completed");
              },
              onChanged: (value) {
                insertedCode = value;
                numberOfInsertedDigits++;
              },
            ),
          ),
          new SizedBox(height: 30.0),
          Center(
            child: GestureDetector(
                onTap: () {
                  verifyInsertedCode(context);
                },
                child: sendVerificationCodeButton()),
          ),
        ],
      ),
    );
  }
}
