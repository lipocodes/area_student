import 'package:areastudent/data/constants.dart';
import 'package:areastudent/tools/auth_service.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share/share.dart';
import 'blocked_users.dart';
import 'contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:areastudent/tools/firebase_methods.dart';
import 'followers.dart';
import 'following.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  MediaQueryData queryData;
  String uid = "";
  bool tempUid = false;
  List<String> profileImages = [];
  String name = "";
  String country = "";
  String region = "";
  String subregion = "";
  String locality = "";
  String academicField = "";
  String birthDate = "";
  String age = "";
  String aboutMe = "";
  List<String> listFollowers = [];
  int numFollowers = 0;
  List<String> listFollowings = [];
  int numFollowings = 0;
  List<String> posts = [];

  List<String> postsCreatorUid = [];
  List<String> postsId = [];
  List<String> postsCreationLatitude = [];
  List<String> postsCreationLongitude = [];
  List<String> postsCreationTime = [];
  List<String> postsText = [];
  List<List<String>> postsTags = [];
  List<List<String>> postsImages = [];

  String gender = "";

  PageController pageController;

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

  Future<void> retrieveUserData() async {   
    this.uid = await inputData();
    if (this.tempUid == true) {
      this.uid = "M0B7RtHW6zYOwkPhcqoHdigwEEs2";
      this.tempUid = true;
    }

    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    try {
      List<dynamic> str1 = snapshot[0].data['profileImages'];
      List<String> str2 = [];
      for (int i = 0; i < str1.length; i++) {
        str2.add(str1[i].toString());
      }
      setState(() {
        this.profileImages = str2;
      });

      this.name =
          snapshot[0].data['firstName'] + "  " + snapshot[0].data['lastName'];
      this.gender = snapshot[0].data['gender'];
      this.country = snapshot[0].data['country'];
      this.region = snapshot[0].data['region'];
      this.subregion = snapshot[0].data['region'];
      this.locality = snapshot[0].data['locality'];
      this.academicField = snapshot[0].data['academicField'];

      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy');
      int yearNow = int.parse(formatter.format(now));
      this.birthDate = snapshot[0].data['birthDate'];
      int yearBirthDate =
          int.parse(this.birthDate.substring(this.birthDate.length - 4));
      int age = yearNow - yearBirthDate;
      this.age = age.toString();

      this.aboutMe = snapshot[0].data['aboutMe'];

      List<dynamic> str3 = snapshot[0].data['followers'];
      List<String> str4 = [];
      for (int i = 0; i < str3.length; i++) {
        str4.add(str3[i].toString());
      }
     this.listFollowers = str4;
      this.numFollowers = str4.length;

      List<dynamic> str5 = snapshot[0].data['following'];
      List<String> str6 = [];
      for (int i = 0; i < str5.length; i++) {
        str6.add(str5[i].toString());
      }
      this.listFollowings = str6;
      this.numFollowings = str6.length;

      List<dynamic> str7 = snapshot[0].data['posts'];
      List<String> str8 = [];
      for (int i = 0; i < str7.length; i++) {
        str8.add(str7.toString());
      }
      this.posts = str8;
      retrievePostsCurrentUser();
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeee= " + e.toString());
    }
  }

  Future<void> retrievePostsCurrentUser() async {
   
    this.uid = await inputData();
    if (this.tempUid == true) {
      this.uid = "M0B7RtHW6zYOwkPhcqoHdigwEEs2";
      this.tempUid = true;
    }

    final QuerySnapshot result = await Firestore.instance
        .collection('posts')
        .where('creatorUid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    for (int i = 0; i < snapshot.length; i++) {
      try {
        this.postsId.add(snapshot[i].data['postId'].toString());
        this.postsCreatorUid.add(snapshot[i].data['creatorUid'].toString());
        this
            .postsCreationLatitude
            .add(snapshot[i].data['creationLatitude'].toString());
        this
            .postsCreationLongitude
            .add(snapshot[i].data['creationLongitude'].toString());
        this.postsCreationTime.add(snapshot[i].data['creationTime'].toString());
        this.postsText.add(snapshot[i].data['text'].toString());

        List<dynamic> str9 = snapshot[i].data['images'];
        List<String> str10 = [];
        for (int i = 0; i < str9.length; i++) {
          str10.add(str9[i].toString());
        }
        this.postsImages.add(str10);

        List<dynamic> str11 = snapshot[i].data['tags'];
        
        List<String> str12 = [];
        for (int i = 0; i < str11.length; i++) {
          str12.add(str11[i].toString());
        }
        this.postsTags.add(str12);
   
      

      } catch (e) {
        print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee= " + e.toString());
      }
    }
      setState(() {
          
        });
  }

  void onPressedFollowingButton() {
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new Followings()));
  }

  void onPressedFollowersButton() {
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new Followers()));
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
            content: const Text(screen12EditProfileWarning),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
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

  Future<bool> _onBackPressed() async {
    //signOut();
    //Navigator.popUntil(context, ModalRoute.withName('/'));
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveUserData();
    pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.6,
    );
  }

  @override
  Widget build(BuildContext context) {
  
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
        resizeToAvoidBottomInset: false, 
        resizeToAvoidBottomPadding: false,
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
        body: new Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                height: 150.0,
                child: largeProfileImage(context, this.profileImages)),
            Positioned(
              child: buttonsOnTopProfileImage(),
            ),
            Positioned(
              top:160,
              height:400,
              child: SingleChildScrollView(
                              child: Column(
                  children: [
                    userDetails(name, age, country, region, academicField, aboutMe, numFollowers, numFollowings, context),
                    SizedBox(height:20.0),
                    SizedBox(
                      height: 800.0 * postsId.length,
                      child: listStoriesProfileScreen(context, this.postsId, this.name, this.profileImages, this.postsCreationTime ,this.postsCreationLatitude, this.postsCreationLongitude, this.postsTags, this.postsText, this.postsImages),
                      ),
                   
                  ],
                ),
              ),
            ),
       
        
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset('assets/macbook.jpg'),
          Text(this.profileImages[index],
              style: TextStyle(color: Colors.deepPurple))
        ],
      ),
    );
  }

  imageSlider(int index) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, widget) {
        double value = 1;
        if (pageController.position.haveDimensions) {
          value = pageController.page - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        }
        return Center(
          child: FittedBox(
            //height: Curves.easeInOut.transform(value) * 200,
            //width: Curves.easeInOut.transform(value) * 300,
            fit: BoxFit.fill,
            child: widget,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Image.network(this.profileImages[index], fit: BoxFit.fitWidth),
      ),
    );
  }
}
