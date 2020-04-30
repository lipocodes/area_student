import 'package:areastudent/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  int performedSetState = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  Firestore firestore = Firestore.instance;
  List blockedUsersFirstName = [];
  int listViewDataUploaded = 0;
  String uid;
  List blockedUsers = [];
  List blockedUid = [];
  List blockedFirstName = [];
  List blockedLastName = [];
  List blockedProfileImage = [];

  Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  getDataOfUsers(String uid) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    try {
      this.blockedUid.add(snapshot[0].data['uid']);
      this.blockedFirstName.add(snapshot[0].data['firstName']);
      this.blockedLastName.add(snapshot[0].data['lastName']);
      this.blockedProfileImage.add('none');
      int len = this.blockedProfileImage.length;
      this.blockedProfileImage[len - 1] = snapshot[0].data['profileImages'][0];
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeee= " + e.toString());
    }
  }

  void listBlockedUsers() async {
    this.uid = await inputData();

    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    this.blockedUsers = snapshot[0].data['blockedUsers'];

    for (int i = 0; i < this.blockedUsers.length; i++) {
      await getDataOfUsers(this.blockedUsers[i]);
    }

    setState(() {});
  }

  removeBlockedUser(index) async {
    this.blockedUsers.removeAt(index);
    await firestore
        .collection("userData")
        .document(this.uid)
        .updateData(({'blockedUsers': blockedUsers}))
        .whenComplete(() {
      blockedUsers = [];
      blockedUid = [];
      blockedProfileImage = [];
      blockedFirstName = [];
      blockedLastName = [];
      listBlockedUsers();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        key: scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black, size: 40.0),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          elevation: 0,
          title: new Text(
            "Blocked Users",
            style: new TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.w900),
          ),
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0, // this will be set when a new tab is tapped
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
        body: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Container(
              height: 220.0,
              child: ListView.builder(
                  itemCount: blockedFirstName.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              //Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: VisitedProfile(firstName[index] +  " " + lastName[index] , email[index], icon[index], listVisitedUid[index])));
                            },
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new CachedNetworkImageProvider(
                                      blockedProfileImage[index] != 'none'
                                          ? blockedProfileImage[index]
                                          : screen13DefaultProfileImage),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150.0,
                            child: new Text(
                              blockedFirstName[index] != null
                                  ? blockedFirstName[index] +
                                      " " +
                                      blockedLastName[index]
                                  : "",
                              style: new TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Poppins",
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          new IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 46.0,
                            ),
                            onPressed: () {
                              removeBlockedUser(index);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
