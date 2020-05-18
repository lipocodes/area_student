import 'package:areastudent/data/constants.dart';
import 'package:flutter/material.dart';
import 'progressdialog.dart';



showSnackBar(String message, final scaffoldKey){
   scaffoldKey.currentState.showSnackBar(
     new SnackBar(
       backgroundColor: Colors.black,

       content: new Text(message, style: new TextStyle(color: Colors.white),),
       ));
}



showPrivacyPolicyDialog(BuildContext context) {

  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () { Navigator.of(context).pop();  },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(screen4TitlePrivacyPolicy),
    content: Text(screen4ContentPrivactPolicy),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



displayProgressDialog(BuildContext context){

 Navigator.of(context).push(new PageRouteBuilder(
   opaque: false,
   pageBuilder: (BuildContext context, _, __) {return new ProgressDialog();}

 ));

}



closeProgressDialog(BuildContext context){
 Navigator.of(context).pop();
}


