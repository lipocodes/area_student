import 'package:areastudent/screens/menu_groups.dart';
import 'package:flutter/material.dart';
import 'package:areastudent/screens/login.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:areastudent/screens/chat_screen.dart';
import 'package:areastudent/screens/group.dart';



//void main() => runApp(MyApp());

void main() async{
 // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, de]);
 Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApp());
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
      },
      theme: ThemeData(
   
        primarySwatch: Colors.blue,
      ),
     
      //home: new AuthService().hanldeAuth(),
      //home: Login(),
      home: MenuGroups(),
      
    );
  }
}


