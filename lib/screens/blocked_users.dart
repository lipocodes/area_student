import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';



class BlockedUsers extends StatefulWidget {
  @override
  _BlockedUsersState createState() => _BlockedUsersState();
}




class _BlockedUsersState extends State<BlockedUsers> {

  final DBRef = FirebaseDatabase.instance.reference();
  List<String> listVisitedUid = List();
  List<String> firstName = List();
  List<String> lastName = List();
  List<String> icon = List();
  List<String> email = List();
  int performedSetState=0;


  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }




  void listBlockedUsers(){

    inputData().then((uid) {
      

      DBRef.child("accounts").child(uid).once().then((
          DataSnapshot dataSnapshot) {
        var arr = dataSnapshot.value;

        List blockedUsers = arr["blockedUsers"];



        for(var i=0; i<blockedUsers.length; i++){

          DBRef.child("accounts").child(blockedUsers[i]).once().then((
              DataSnapshot dataSnapshot) {
            Map<dynamic, dynamic> values = dataSnapshot.value;

            try {
              values.forEach((key, values) {
                if (key == "uid") listVisitedUid.add(values.toString());
                if (key == "valueFirstName")
                  firstName.add(values.toString());
                else if (key == "valueLastName")
                  lastName.add(values.toString());
                else if (key == "profilePhoto") icon.add(values.toString());
                else if (key == "email") email.add(values.toString());
              });
            } catch(e) {}

          }).then((res) {setState(() {
            this.performedSetState=1;
          });});
        }

      }).then((res) {});

    });

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }


  @override
  Widget build(BuildContext context) {


     if(performedSetState == 0){
       listBlockedUsers();
       return Container();
     }

     if(performedSetState == 1) {
       return    SafeArea(
         child: MaterialApp(
           home: Scaffold(
               body:  Column(
                 children: <Widget>[
                   ListTile(
                     title: Text('Blocked Users', style: new TextStyle(
                       fontSize: 20.0,
                     ),),

                   ),
                   GestureDetector(

                     child: Container(
                       height:220.0,

                       child:  ListView.builder(
                           itemCount: firstName.length,
                           itemBuilder: (BuildContext ctxt, int index) {
                             return GestureDetector(
                               onTap: () {
                                 //Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: VisitedProfile(firstName[index] +  " " + lastName[index] , email[index], icon[index], listVisitedUid[index])));
                               },
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                 children: <Widget>[

                                   Container(
                                     width: 50.0,
                                     height: 50.0,
                                     decoration: new BoxDecoration(
                                       shape: BoxShape.circle,
                                       image: new DecorationImage(
                                         fit: BoxFit.fill,
                                         image: new CachedNetworkImageProvider(icon[index],),

                                       ),
                                     ),
                                   ),

                                   new Text(firstName[index]),
                                   new Text(lastName[index]),



                                 ],
                               ),
                             );
                           }
                       ),
                     ),
                   ),
                 ],
               )
           ),
         ),
       );
     }




  }
}
