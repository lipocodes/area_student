import 'package:flutter/material.dart';




class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
          child: new Text("Here will be the Profile screen", style: TextStyle(fontSize: 25.0),)
      ),
    );
  }
}