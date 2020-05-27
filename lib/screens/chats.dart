import 'package:flutter/material.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/cupertino.dart';
import 'menu_groups.dart';
import 'meet.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int indexBottomBar = 0;
  String uid="";

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      return uid;
    } catch (e) {
      return "";
    }
  }


   getMyUid() async{
     this.uid = await inputData();
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyUid();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Text(
              "Chats",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 24),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                size: 40,
              ),
              color: Colors.black87,
              onPressed: () {
                showSnackBar(
                    "In the future - Inbox will be here!", scaffoldKey);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        onTap: (int index) {
          setState(() {
            this.indexBottomBar = index;
          });

          if (this.indexBottomBar == 0) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Profile()));
          }

          if (this.indexBottomBar == 1) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new MenuGroups()));
          } else if (this.indexBottomBar == 3) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Meet(this.uid)));
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.perm_identity, size: 30.0),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.group, size: 30.0),
            title: new Text('Groups'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30.0), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 30.0),
              title: Text('Meet')),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 30.0),
              title: Text('Chats'))
        ],
      ),
    );
  }
}
