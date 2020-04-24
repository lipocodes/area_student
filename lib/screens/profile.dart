import 'package:areastudent/tools/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

   Future<void> signOut() async {
     await AuthService().signOut();
     //exit(0);
     Navigator.popUntil(context, ModalRoute.withName('/'));
   }

  @override
  Widget build(BuildContext context) {
         return new Scaffold(
      appBar: AppBar(
        elevation: 0,
         iconTheme: IconThemeData(
    color: Colors.black, //change your color here
       ),
        title: new Text("",),
        backgroundColor: Colors.white,
        
      ),
      body: new Center(
          child: Column(
            children: [
              new Text("This is Profile Screen (screen 9).  You are signed in!"),
              SizedBox(height:50.0,),
              new RaisedButton(
                child: new Text("Signout"),
                onPressed: () {signOut();},
                ),
            ],
          ),
      ),
    );
  }
}