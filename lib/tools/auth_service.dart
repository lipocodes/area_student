
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:areastudent/screens/profile.dart';
import 'package:areastudent/screens/login.dart';

class AuthService {

 hanldeAuth() {

   return StreamBuilder(
     stream: FirebaseAuth.instance.onAuthStateChanged, 
     builder: (BuildContext context, snapshot) {
      
        if(snapshot.hasData){
          return Profile();
        }
        else{
          return Login();
        }
       },
   );
 }


 signOut() {
   FirebaseAuth.instance.signOut();
 }


 signIn(AuthCredential authCreds) {
   FirebaseAuth.instance.signInWithCredential(authCreds);
 }


}