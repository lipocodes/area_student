import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGoogle extends StatefulWidget {
  @override
  _AuthGoogleState createState() => _AuthGoogleState();
}

class _AuthGoogleState extends State<AuthGoogle> {

 bool _isLoggedIn = false;
GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);


  _login() async{
    try{
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err){
      print(err);
    }
  }

  _logout(){
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}