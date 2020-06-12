//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:areastudent/screens/login.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:areastudent/screens/meet.dart';
import 'package:areastudent/tools/widgets.dart';



 /* void checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.storage,
      ].request();
  }*/

//void main() => runApp(MyApp());

void main() async{


  
 // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, de]);
 Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApp());

  retrieveNotifications();  //in widgets.dart

    //checkPermissions();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/login' :(context) => Login(),
        //'/chat_screen' : (context) => ChatScreen('M0B7RtHW6zYOwkPhcqoHdigwEEs2','Mishel Nisimov','aaaaa aaaaaa','https://www.frk.co.il/wp-content/uploads/2018/10/jobs1.png','https://firebasestorage.googleapis.com/v0/b/area-student-d501b.appspot.com/o/userData%2FM0B7RtHW6zYOwkPhcqoHdigwEEs2%2FM0B7RtHW6zYOwkPhcqoHdigwEEs2.0.jpg?alt=media&token=f49fdb42-f54c-40f9-b13b-df87232c6c04'),
        '/meet' :  (context) => Meet(""),
      },
      theme: ThemeData(
   
        primarySwatch: Colors.blue,
      ),
     
      //home: new AuthService().hanldeAuth(),
      home: Login(),
      //home: Meet('UXlUwUGhs3dwYp6m7h6k9kJHlOJ3'),
      //home: Chats(),
      
    );
  }
}


