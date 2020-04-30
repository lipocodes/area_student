import 'package:areastudent/data/constants.dart';
import 'package:areastudent/tools/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'blocked_users.dart';
import 'contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:areastudent/tools/firebase_methods.dart';



class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseMethods firebaseMethods = new FirebaseMethods();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void onTappedSettingsButton(String choice) {
    if (choice == screen12Logout)
      signOut();
    else if (choice == screen12RecommendToFriend) {
      Share.share(
          'check out the app "Area Student"  on Google Play OR Play Store!',
          subject: 'I enjoy it!!');
      Navigator.of(context).pop();
    } else if (choice == screen12ContactUs) {
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new Contact()));
    } else if (choice == screen12AboutUs) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(screen12AboutUs),
            content: const Text(screen12AboutUsBody),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (choice == screen12BlockedUsers) {
      Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new BlockedUsers()));
  
    } else if (choice == screen12Settings) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Settings'),
            content:
                const Text('Here will be the settings screen in the future!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (choice == screen12EditProfile) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Profile'),
            content: const Text(
                'Here will be the Edit Profile screen in the future!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  onPressedSettingsButton() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Settings'),
            content: Container(
              width: double.maxFinite,
              height: 400.0,
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline, size: 30.0),
                    title: Text(screen12EditProfile),
                    onTap: () {
                      onTappedSettingsButton(screen12EditProfile);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, size: 30.0),
                    title: Text(screen12Settings),
                    onTap: () {
                      onTappedSettingsButton(screen12Settings);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.block, size: 30.0),
                    title: Text(screen12BlockedUsers),
                    onTap: () {
                      onTappedSettingsButton(screen12BlockedUsers);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline, size: 30.0),
                    title: Text(screen12AboutUs),
                    onTap: () {
                      onTappedSettingsButton(screen12AboutUs);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.import_contacts, size: 30.0),
                    title: Text(screen12ContactUsTitle),
                    onTap: () {
                      onTappedSettingsButton(screen12ContactUsTitle);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.thumb_up, size: 30.0),
                    title: Text(screen12RecommendToFriend),
                    onTap: () {
                      onTappedSettingsButton(screen12RecommendToFriend);
                    },
                  ),
                  SizedBox(height: 10.0),
                  Divider(color: Colors.grey[500]),
                  SizedBox(height: 10.0),
                  ListTile(
                    leading: Icon(Icons.wrap_text, size: 30.0),
                    title: Text(screen12Logout),
                    onTap: () {
                      onTappedSettingsButton(screen12Logout);
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<void> signOut() async {
    await firebaseMethods.logout();
    //exit(0);
    //Navigator.popUntil(context, ModalRoute.withName('/login'));
    Navigator.pushNamed(context, '/login');
    
  }


  Future<bool> _onBackPressed() async{
   //signOut();
   //Navigator.popUntil(context, ModalRoute.withName('/'));
   return true;
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: new Text(
            "",
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: new IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: onPressedSettingsButton)),
          ],
        ),
      ),
    );
  }
}
