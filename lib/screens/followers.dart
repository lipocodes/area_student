import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:areastudent/data/constants.dart';

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  int performedSetState = 0;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  Firestore firestore = Firestore.instance;
  String uid;
  List followers = [];
  List followerUid = [];
  List followerFirstName = [];
  List followerLastName = [];
  List followerProfileImage = [];
  bool tempUid = false;

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      return uid;
    } catch (e) {
      this.tempUid = true;
      return "";
    }
  }

  getDataOfUsers(String uid) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    try {
      this.followerUid.add(snapshot[0].data['uid']);
      this.followerFirstName.add(snapshot[0].data['firstName']);
      this.followerLastName.add(snapshot[0].data['lastName']);
      this.followerProfileImage.add('none');
      int len = this.followerProfileImage.length;
      this.followerProfileImage[len - 1] = snapshot[0].data['profileImages'][0];
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeee= " + e.toString());
    }
  }

  void listFollowers() async {
    this.uid = await inputData();
    if (this.tempUid == true) {
      this.uid = "M0B7RtHW6zYOwkPhcqoHdigwEEs2";
      this.tempUid = true;
    }

    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    this.followers = snapshot[0].data['followers'];

    for (int i = 0; i < this.followers.length; i++) {
      await getDataOfUsers(this.followers[i]);
    }

    setState(() {});
  }

  removeFollower(index) async {
    this.followers.removeAt(index);
    await firestore
        .collection("userData")
        .document(this.uid)
        .updateData(({'followers': followers}))
        .whenComplete(() {
      followers = [];
      followerUid = [];
      followerProfileImage = [];
      followerFirstName = [];
      followerLastName = [];
      listFollowers();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listFollowers();
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
            "Followers",
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
                  itemCount: followerFirstName.length,
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
                              child: new CachedNetworkImage(
                                imageUrl: followerProfileImage[index],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 200.0,
                            child: new Text(
                              followerFirstName[index] != null
                                  ? followerFirstName[index] +
                                      " " +
                                      followerLastName[index]
                                  : "",
                              style: new TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Poppins",
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 80.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFFB3F5FC),
                                      Color(0xFF81D4FA),
                                      Color(0xFF29B6F6),
                                    ],
                                  ),
                                borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),  
                              child: new FlatButton(
                                 color: Colors.transparent,
                                onPressed: () {
                              removeFollower(index);
                            }, //the click event is impolemented in the screen classes
                                padding: const EdgeInsets.all(0.0),
                                child: new Text(screen10Delete ,  style: TextStyle(
                                      fontSize: 18, color: Colors.white,)),
                              ),
                            ),
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
