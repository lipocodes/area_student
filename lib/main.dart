import 'package:flutter/material.dart';
import 'package:areastudent/screens/login.dart';
import 'package:areastudent/tools/auth_service.dart';


void main() => runApp(MyApp());

/*void main() async{
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, de]);
  runApp(MyApp());
}*/

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
   
        primarySwatch: Colors.blue,
      ),
     
      home: new AuthService().hanldeAuth(),
    );
  }
}


