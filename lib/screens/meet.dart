import 'package:areastudent/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/cupertino.dart';
import 'menu_groups.dart';
import 'profile.dart';
import 'search_options.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:areastudent/screens/images_in_large.dart';
import 'chats.dart';
import 'notifications.dart';

String targetUidd;
String textBlockUser = "";
List<String> globalProfilelImages = [];
String globalName;
List<String> postsCreatorUid = [];
List<String> postsId = [];
List<String> postsCreationCountry = [];
List<String> postsCreationRegion = [];
List<String> postsCreationSubRegion = [];
List<String> postsCreationTime = [];
List<String> postsText = [];
List<List<String>> postsTags = [];
List<List<String>> postsImages = [];
List<File> postImageList = [];
String myUid;
String myProfileImage = "";
String myName = "";

class Meet extends StatefulWidget {
  String targetUid;
  Meet(this.targetUid);
  @override
  _MeetState createState() => _MeetState();
}

class _MeetState extends State<Meet> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int indexBottomBar = 0;
  String uid;
  int myIndex = 0;

  Future<void> retrievePostsCurrentUser() async {
    //this.uid = await inputData();
    this.uid = targetUidd;

    final QuerySnapshot result = await Firestore.instance
        .collection('posts')
        .where('creatorUid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    postsId = [];
    postsCreatorUid = [];
    postsCreationCountry = [];
    postsCreationRegion = [];
    postsCreationSubRegion = [];
    postsCreationTime = [];
    postsText = [];
    postsTags = [];
    postsImages = [];

    for (int i = 0; i < snapshot.length; i++) {
      try {
        postsId.add(snapshot[i].data['postId'].toString());

        postsCreatorUid.add(snapshot[i].data['creatorUid'].toString());
        postsCreationCountry
            .add(snapshot[i].data['creationCountry'].toString());
        postsCreationRegion.add(snapshot[i].data['creationRegion'].toString());
        postsCreationSubRegion
            .add(snapshot[i].data['creationSubRegion'].toString());
        postsCreationTime.add(snapshot[i].data['creationTime'].toString());
        postsText.add(snapshot[i].data['text'].toString());

        List<dynamic> str9 = snapshot[i].data['images'];

        List<String> str10 = [];

        for (int i = 0; i < str9.length; i++) {
          str10.add(str9[i].toString());
        }

        postsImages.add(str10);

        List<dynamic> str11 = snapshot[i].data['tags'];

        List<String> str12 = [];
        for (int i = 0; i < str11.length; i++) {
          str12.add(str11[i].toString());
        }
        postsTags.add(str12);
      } catch (e) {
        print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee= " + e.toString());
      }
    }

    postsId = postsId.reversed.toList();
    postsCreatorUid = postsCreatorUid.reversed.toList();
    postsCreationCountry = postsCreationCountry.reversed.toList();
    postsCreationRegion = postsCreationRegion.reversed.toList();
    postsCreationSubRegion = postsCreationSubRegion.reversed.toList();
    postsCreationTime = postsCreationTime.reversed.toList();
    postsTags = postsTags.reversed.toList();
    postsText = postsText.reversed.toList();
    postsImages = postsImages.reversed.toList();

    setState(() {});
  }

  getMyUid() async {
    String uid = await inputData();
    myUid = uid;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    targetUidd = widget.targetUid;

    getMyUid();

    /*retrievePostsCurrentUser().then((value) {
      setState(() {});
    });*/
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
              "Meet",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 24),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                size: 40,
              ),
              color: Colors.black87,
              onPressed: () async {
                await Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new SearchOptions()));
                setState(() {});
              },
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                size: 40,
              ),
              color: Colors.black87,
              onPressed: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Notifications()));
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 2,
        onTap: (int index) {
          setState(() {
            this.indexBottomBar = index;
          });

          if (this.indexBottomBar == 0) {

             Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => new Profile(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 2000),
                ),
              );

            //Navigator.of(context).push(new CupertinoPageRoute(
              //  builder: (BuildContext context) => new Profile()));
          } else if (this.indexBottomBar == 1) {

            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => new MenuGroups(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 2000),
                ),
              );

            //Navigator.of(context).push(new CupertinoPageRoute(
              //  builder: (BuildContext context) => new MenuGroups()));
          } else if (this.indexBottomBar == 3) {

            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => new Chats(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 2000),
                ),
              );

            //Navigator.of(context).push(new CupertinoPageRoute(
              //  builder: (BuildContext context) => new Chats()));
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
              icon: Icon(Icons.favorite_border, size: 30.0),
              title: Text('Meet')),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 30.0),
              title: Text('Chats'))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          searchUserBox(context),
          PersonalCard(),
          //Posts(),
        ]),
      ),
    );
  }
}

class Posts extends StatefulWidget {
  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  double lengthTextBoxPost(int numWords) {
    double d = numWords / 5;
    double necessaryHeight = d * 20;
    return d * 10;
  }

  @override
  Widget build(BuildContext context) {
    if (globalName == null || globalProfilelImages == null) return Container();

    return Column(
      children: [
        SizedBox(height: 50.0),
        postsId.length > 0
            ? SizedBox(
                height: 400,
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: postsId.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, right: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            new CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new Meet(targetUidd)));
                                      },
                                      child: new Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new NetworkImage(
                                                      globalProfilelImages[
                                                          0])))),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                        globalName +
                                            "\n" +
                                            postsCreationCountry[index] +
                                            "," +
                                            postsCreationRegion[index] +
                                            "," +
                                            postsCreationSubRegion[index] +
                                            "\n" +
                                            timestampToTimeGap(
                                                postsCreationTime[index]),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w800)),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    postsTags[index][0].toString() ==
                                            '123456789'
                                        ? Container()
                                        : Text(postsTags[index][0].toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16.0)),
                                    SizedBox(width: 20.0),
                                    postsTags[index][1].toString() ==
                                            '123456789'
                                        ? Container()
                                        : Text(postsTags[index][1].toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16.0)),
                                    SizedBox(width: 20.0),
                                    postsTags[index][2].toString() ==
                                            '123456789'
                                        ? Container()
                                        : Text(postsTags[index][2].toString(),
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16.0)),
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                !postsImages[index].contains('123456789')
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                new CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        new ImageInLarge(
                                                          postsImages[index][0],
                                                        )));
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: postsImages[index][0],
                                            placeholder: (context, url) =>
                                                Container(
                                              child: Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                            fadeInCurve: Curves.easeIn,
                                            fadeInDuration:
                                                Duration(milliseconds: 1000),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: 10.0),
                                postsImages[index].length > 1
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                new CupertinoPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        new ImageInLarge(
                                                          postsImages[index][1],
                                                        )));
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: postsImages[index][1],
                                            placeholder: (context, url) =>
                                                Container(
                                              child: Center(
                                                  child:
                                                      new CircularProgressIndicator()),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                            fadeInCurve: Curves.easeIn,
                                            fadeInDuration:
                                                Duration(milliseconds: 1000),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: 10.0),
                                postsText[index].length > 0
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height: lengthTextBoxPost(
                                            postsText[index].length),
                                        child: Text(
                                          postsText[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16),
                                          textAlign: TextAlign.justify,
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: 20.0),
                                Divider(
                                  thickness: 10,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class PersonalCard extends StatefulWidget {
  @override
  _PersonalCardState createState() => _PersonalCardState();
}

class _PersonalCardState extends State<PersonalCard> {
  String uid,
      name,
      gender,
      country,
      region,
      subregion,
      locality,
      academicField,
      aboutMe;
  int age, indexProfileImage = 0;
  List<String> profileImages;
  int numFollowers;
  int numFollowing;
  String textFollowButton = "Follow";
  String textBlockUser = "";

  int myIndex = 0;
  followThisUser() async {
    int now = new DateTime.now().millisecondsSinceEpoch;
    
    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    List<dynamic> str1 = snapshot[0].data['followers'];
    List<String> followers = [];
    for (int i = 0; i < str1.length; i++) {
      followers.add(str1[i].toString());
    }

    followers.add(myUid);

    try {
      String uid = await inputData();
      await Firestore.instance
          .collection("userData")
          .document(this.uid)
          .updateData({'followers': followers});
    } catch (e) {}


    final QuerySnapshot result1 = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot1 = result.documents;



    String uid = await inputData(); 
    final QuerySnapshot result2 = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot2 = result2.documents;
    List<dynamic> str2 = snapshot2[0].data['following'];
    List<String> following = [];
    for (int i = 0; i < str2.length; i++) {
      following.add(str2[i].toString());
    }
    following.add(targetUidd);
    try {
      await Firestore.instance
          .collection("userData")
          .document(uid)
          .updateData({'following': following});
    } catch (e) {}



    str1 = snapshot1[0].data['notifications'];
    List<String> notifications = [];
    for (int i = 0; i < str1.length; i++) {
      notifications.add(str1[i].toString());
    }

    notifications.add("^^^" +
        myProfileImage +
        "^^^" +
        myName +
        "^^^" +
        now.toString() +
        "^^^" +
        "Followed You" +
        "^^^" +
        myUid);
    try {
      String uid = await inputData();

      await Firestore.instance
          .collection("userData")
          .document(targetUidd)
          .updateData({'notifications': notifications});

      setState(() {
        this.textFollowButton = "Unfollow";
      });
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeee followThisUser");
    }
  }

  unfollowThisUser() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    List<dynamic> str1 = snapshot[0].data['followers'];
    List<String> followers = [];
    for (int i = 0; i < str1.length; i++) {
      followers.add(str1[i].toString());
    }
    followers.remove(myUid);
    try {
      String uid = await inputData();
      await Firestore.instance
          .collection("userData")
          .document(this.uid)
          .updateData({'followers': followers});
      setState(() {
        this.textFollowButton = "Follow";
      });
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeee followThisUser");
    }

    final QuerySnapshot result1 = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: targetUidd)
        .getDocuments();
    final List<DocumentSnapshot> snapshot1 = result.documents;

    str1 = snapshot1[0].data['notifications'];
    List<String> notifications = [];
    for (int i = 0; i < str1.length; i++) {
      notifications.add(str1[i].toString());
    }

    for (int h = 0; h < notifications.length; h++) {
      if (notifications[h].contains('Followed You') &&
          notifications[h].contains(myUid)) {
        notifications.removeAt(h);
      }
    }

    await Firestore.instance
        .collection("userData")
        .document(targetUidd)
        .updateData({'notifications': notifications});
  }

  retrieveUserData() async {
    if (targetUidd.length > 10) {
      this.uid = targetUidd;
    } else {
      this.uid = "";
    }

    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    try {
      List<dynamic> str1 = snapshot[0].data['profileImages'];
      List<String> str2 = [];
      for (int i = 0; i < str1.length; i++) {
        str2.add(str1[i].toString());
      }
      this.profileImages = str2;
      globalProfilelImages = this.profileImages;

      this.name =
          snapshot[0].data['firstName'] + "  " + snapshot[0].data['lastName'];
      globalName = this.name;

      this.gender = snapshot[0].data['gender'];
      this.country = snapshot[0].data['country'];
      this.region = snapshot[0].data['region'];
      this.subregion = snapshot[0].data['subRegion'];
      this.locality = snapshot[0].data['locality'];
      this.academicField = snapshot[0].data['academicField'];
      this.aboutMe = snapshot[0].data['aboutMe'];
      List followers = snapshot[0].data['followers'];
      this.numFollowers = followers.length;
      List following = snapshot[0].data['following'];
      this.numFollowing = following.length;

      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy');
      int yearNow = int.parse(formatter.format(now));
      String birthDate = snapshot[0].data['birthDate'];
      int yearBirthDate = int.parse(birthDate.substring(birthDate.length - 4));
      this.age = yearNow - yearBirthDate;

      setState(() {});
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeee= " + e.toString());
    }
  }

  switchNextMeet(bool op) async {
    final QuerySnapshot result =
        await Firestore.instance.collection('userData').getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    List<String> userListUid = [];
    List<String> userListGender = [];
    List<String> userListAcademicField = [];
    List<String> userListLatitude = [];
    List<String> userListLongitude = [];

    for (int i = 0; i < snapshot.length; i++) {
      userListUid.add(snapshot[i].data['uid'].toString());
      userListGender.add(snapshot[i].data['gender'].toString());
      userListAcademicField.add(snapshot[i].data['academicField'].toString());
      userListLatitude.add(snapshot[i].data['latitude'].toString());
      userListLongitude.add(snapshot[i].data['longitude'].toString());
    }

    //filter the users based on the user's preferences
    List<String> filteredUserListUid = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String prefGender = prefs.getString('searchSelectedGender') ?? "Both";
    String prefAcademicField =
        prefs.getString('searchSelectedAcademicField') ?? "All Fields";
    int prefDistance = prefs.getInt('searchSelectedDistance') ?? 500;
    bool neededTestGender = false;
    bool neededTestAcademicField = false;
    if (prefGender == "Male" || prefGender == "Female") neededTestGender = true;
    if (prefAcademicField != "All Fields") neededTestAcademicField = true;

    for (int i = 0; i < userListUid.length; i++) {
      double distancePoints = await distanceBetweenPoints(
          userListLatitude[i], userListLongitude[i]);

      if (neededTestGender == true && neededTestAcademicField == true) {
        if (userListGender[i] == prefGender &&
            userListAcademicField[i] == prefAcademicField &&
            distancePoints < prefDistance) {
          filteredUserListUid.add(userListUid[i]);
        }
      } else if (neededTestGender == true) {
        if (userListGender[i] == prefGender && distancePoints < prefDistance) {
          filteredUserListUid.add(userListUid[i]);
        }
      } else if (neededTestAcademicField == true) {
        if (userListAcademicField[i] == prefAcademicField &&
            distancePoints < prefDistance) {
          filteredUserListUid.add(userListUid[i]);
        }
      } else if (distancePoints < prefDistance) {
        filteredUserListUid.add(userListUid[i]);
      }
      //else{return;}
    }

    if (filteredUserListUid.length == 0) return;

    int prefMyIndex = prefs.getInt('myIndex') ?? 0;

    if (op == false && prefMyIndex > 0) {
      prefMyIndex = prefMyIndex - 1;
    } else if (op == false && prefMyIndex == 0) {
      prefMyIndex = filteredUserListUid.length - 1;
    } else if (op == true && prefMyIndex == (filteredUserListUid.length - 1)) {
      prefMyIndex = 0;
    } else {
      prefMyIndex = prefMyIndex + 1;
    }

    targetUidd = filteredUserListUid[prefMyIndex];

    prefs.setInt('myIndex', prefMyIndex);

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new Meet(targetUidd)));

    //this.retrieveUserData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (this.uid == null ||
        this.uid.length == 0 ||
        this.numFollowers == null ||
        this.numFollowing == null) return Container();

    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              child: Container(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      profileImages != null && profileImages.length > 0
                          ? GestureDetector(
                              onTap: () {
                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.height,
                                        height:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    profileImages[
                                                        indexProfileImage]),
                                                fit: BoxFit.cover)),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: CachedNetworkImage(
                                  imageUrl: profileImages[indexProfileImage],
                                  placeholder: (context, url) => Container(
                                    child: Center(
                                        child: new CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                  fadeInCurve: Curves.easeIn,
                                  fadeInDuration: Duration(milliseconds: 1000),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            /*Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white70,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: IconButton(
                        icon: Icon(Icons.fast_rewind),
                        iconSize: 35,
                        color: Colors.white,
                        onPressed: () {
                          switchNextMeet(false);
                        }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white70,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: IconButton(
                      icon: Icon(
                        Icons.fast_forward,
                      ),
                      iconSize: 35,
                      color: Colors.white,
                      onPressed: () {
                        switchNextMeet(true);
                      },
                    ),
                  ),
                ],
              ),
            ),*/
            Positioned(
              top: 25,
              bottom: 0,
              right: 10,
              left: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white70,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                        ),
                        iconSize: 35,
                        color: Colors.white,
                        onPressed: () {
                          //switchNextMeet(false);

                          setState(() {
                            if (indexProfileImage > 0) {
                              indexProfileImage = indexProfileImage - 1;
                            } else {
                              indexProfileImage = this.profileImages.length - 1;
                            }
                          });
                        }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white70,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                      ),
                      iconSize: 35,
                      color: Colors.white,
                      onPressed: () {
                        //switchNextMeet(true);
                        setState(() {
                          if (indexProfileImage ==
                              this.profileImages.length - 1) {
                            indexProfileImage = 0;
                          } else {
                            indexProfileImage = indexProfileImage + 1;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        userDetails(
            this.name,
            this.age.toString(),
            this.country,
            this.region,
            this.academicField,
            this.aboutMe,
            this.numFollowers,
            numFollowing,
            context),
        if (myUid != targetUidd) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                onPressed: () {
                  if (this.textFollowButton == "Follow")
                    this.followThisUser();
                  else
                    this.unfollowThisUser();
                }, //the click event is impolemented in the screen classes
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFB3F5FC),
                          Color(0xFF81D4FA),
                          Color(0xFF29B6F6),
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      )),
                  padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                  child: new Text(this.textFollowButton,
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new ChatScreen(
                            this.uid,
                            name,
                            " ",
                            " ",
                            this.profileImages[indexProfileImage].toString())));
                  },
                  child: Icon(Icons.chat_bubble_outline, size: 45)),
            ],
          ),
        ],
      ],
    );
  }
}

showDialogSettings(context) async {
  bool yesNo = await checkIsUserBlocked(targetUidd);
  if (yesNo == true)
    textBlockUser = "Unblock User";
  else
    textBlockUser = "Block User";
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              FlatButton(
                child: Text(textBlockUser),
                onPressed: () {
                  if (textBlockUser == "Block User")
                    blockUser(targetUidd, true);
                  else
                    blockUser(targetUidd, false);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Report User'),
                onPressed: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new Contact()));
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

showDialogSearchOptions(context) {
  double desiredDistance = 0;
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new SearchOptions()));
            },
            child: Row(
              children: [
                Text("Search Option",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          content: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Maximum Distance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Row(
                children: [
                  Slider(
                    value: 0,
                    onChanged: (newValue) {
                      desiredDistance = newValue;
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () {
                print("OK");
              },
            ),
            new FlatButton(
              child: new Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }).then((value) => Navigator.of(context).pop());
}

Future<bool> checkIsUserBlocked(String uidBlockedUser) async {
  String uid = await inputData();
  final QuerySnapshot result = await Firestore.instance
      .collection('userData')
      .where('uid', isEqualTo: uid)
      .getDocuments();
  final List<DocumentSnapshot> snapshot = result.documents;

  List<dynamic> str1 = snapshot[0].data['blockedUsers'];
  List<String> str2 = [];
  for (int i = 0; i < str1.length; i++) {
    str2.add(str1[i].toString());
  }
  if (str2.contains(uidBlockedUser))
    return true;
  else
    return false;
}

blockUser(String uidBlockedUser, bool op) async {
  String uid = await inputData();
  final QuerySnapshot result = await Firestore.instance
      .collection('userData')
      .where('uid', isEqualTo: uid)
      .getDocuments();
  final List<DocumentSnapshot> snapshot = result.documents;

  List<dynamic> str1 = snapshot[0].data['blockedUsers'];
  List<String> str2 = [];
  for (int i = 0; i < str1.length; i++) {
    str2.add(str1[i].toString());
  }
  if (op == true) {
    str2.add(targetUidd);
    textBlockUser = "Unblock User";
  } else {
    str2.remove(targetUidd);
    textBlockUser = "Block User";
  }

  await Firestore.instance
      .collection("userData")
      .document(uid)
      .updateData({'blockedUsers': str2});

  final QuerySnapshot result2 = await Firestore.instance
      .collection('userData')
      .where('uid', isEqualTo: targetUidd)
      .getDocuments();
  final List<DocumentSnapshot> snapshot1 = result.documents;

  str1 = snapshot[0].data['blockedBy'];
  if (str1 == null) str1 = [];

  str2 = [];
  for (int i = 0; i < str1.length; i++) {
    str2.add(str1[i].toString());
  }
  if (op == true) {
    str2.add(uid);
  } else {
    str2.remove(uid);
  }

  await Firestore.instance
      .collection("userData")
      .document(targetUidd)
      .updateData({'blockedBy': str2});
}

Future<String> inputData() async {
  try {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    myUid = user.uid.toString();
    myProfileImage = user.photoUrl.toString();
    myName = user.displayName.toString();
    return myUid;
  } catch (e) {
    return "";
  }
}

Widget searchUserBox(context) {
  TextEditingController controllerSearchName = new TextEditingController();

  String str1;
  List<String> uid1 = [];
  List<String> profileImage1 = [];
  List<String> name1 = [];
  List<String> uid2 = [];
  List<String> profileImage2 = [];
  List<String> name2 = [];
  List<String> uid3 = [];
  List<String> profileImage3 = [];
  List<String> name3 = [];
  List suggestions = [];
  List<String> str2;

  String convertUpperCase(query) {
    String str = query.toString();

    for (var i = 0; i < str.length; i++) {
      if (i == 0 || (i > 0 && (str.substring(i - 1, i)) == " ")) {
        str = str.substring(0, i) +
            str.substring(i, i + 1).toUpperCase() +
            str.substring(i + 1);
      } else {
        str = str.substring(0, i) +
            str.substring(i, i + 1).toLowerCase() +
            str.substring(i + 1);
      }
    }

    return str;
  }

  Future<List> searchUsers() async {
    String searchText = "";
    searchText = controllerSearchName.text;

    searchText = convertUpperCase(searchText);

    if (searchText.length > 1 &&
        searchText.substring(searchText.length - 1) == " ") {
      var input = searchText;
      var str = input.split(" ");
      //print("ddddddddddddddd= "  + str.toString());

      if (str.length == 2) {
        uid1 = [];
        profileImage1 = [];
        name1 = [];
        //search for the input word in user firstName
        final QuerySnapshot result = await Firestore.instance
            .collection('userData')
            .where("firstName", isEqualTo: str[0])
            .getDocuments();
        final List<DocumentSnapshot> snapshot = result.documents;

        for (int i = 0; i < snapshot.length; i++) {
          uid1.add(snapshot[i].data['uid'].toString());
          profileImage1.add(snapshot[i].data['profileImages'][0].toString());
          name1.add(snapshot[i].data['firstName'].toString() +
              "  " +
              snapshot[i].data['lastName'].toString());
        }

        //check which of these users has blocked me
        //retrieve list of users who have blocked me
        String uid = await inputData();
        final QuerySnapshot result1 = await Firestore.instance
            .collection('userData')
            .where('uid', isEqualTo: uid)
            .getDocuments();
        final List<DocumentSnapshot> snapshot1 = result1.documents;

        List<dynamic> str1 = snapshot1[0].data['blockedBy'];
        str2 = [];
        for (int i = 0; i < str1.length; i++) {
          str2.add(str1[i].toString()); //list of blockers
        }

        for (int i = 0; i < uid1.length; i++) {
          //going over suggestions, filtering blockers
          if (str2.contains(uid1[i])) {
            uid1.removeAt(i);
            name1.remove(i);
            profileImage1.removeAt(i);
          }
        }
        print("1st proposal is:  " + uid1.toString());
      } else if (str.length == 3) {
        uid2 = [];
        profileImage2 = [];
        name2 = [];
        final QuerySnapshot result = await Firestore.instance
            .collection('userData')
            .where("lastName", isEqualTo: str[1])
            .getDocuments();
        final List<DocumentSnapshot> snapshot = result.documents;

        String str1;

        for (int i = 0; i < snapshot.length; i++) {
          uid2.add(snapshot[i].data['uid'].toString());
          profileImage2.add(snapshot[i].data['profileImages'][0].toString());
          name2.add(snapshot[i].data['firstName'].toString() +
              "  " +
              snapshot[i].data['lastName'].toString());
        }

        print("2nd proposal is:  " + uid2.toString());

        uid3 = [];
        profileImage3 = [];
        name3 = [];
        if (uid1.length > uid2.length) {
          for (int i = 0; i < uid2.length; i++) {
            if (uid1.contains(uid2[i])) {
              uid3.add(uid2[i]);
              profileImage3.add(profileImage2[i]);
              name3.add(name2[i]);
            }
          }
        } else {
          for (int i = 0; i < uid1.length; i++) {
            if (uid2.contains(uid1[i])) {
              uid3.add(uid1[i]);
              profileImage3.add(profileImage1[i]);
              name3.add(name1[i]);
            }
          }
        }

        for (int i = 0; i < uid3.length; i++) {
          //going over suggestions, filtering blockers
          if (str2.contains(uid3[i])) {
            uid3.removeAt(i);
            name3.remove(i);
            profileImage3.removeAt(i);
          }
        }

        print("Combined propsal is: " + uid3.toString());
      }

      if (uid3.length > 0) {
        suggestions = [];

        for (int i = 0; i < uid3.length; i++) {
          var temp = {
            'uid': '${uid3[i]}',
            'profileImage': '${profileImage3[0]}',
            'name': '${name3[i]}'
          };
          suggestions.add(temp);
        }
        return suggestions;
      } else {
        suggestions = [];

        for (int i = 0; i < uid1.length; i++) {
          var temp = {
            'uid': '${uid1[i]}',
            'profileImage': '${profileImage1[0]}',
            'name': '${name1[i]}'
          };
          suggestions.add(temp);
        }
        return suggestions;
      }
    } else {
      var temp = [];
      return temp;
    }
  }

  return TypeAheadField(
    textFieldConfiguration: TextFieldConfiguration(
        controller: controllerSearchName,
        autofocus: false,
        style: DefaultTextStyle.of(context).style.copyWith(
              fontStyle: FontStyle.italic,
              fontSize: 16,
              color: Colors.black,
            ),
        decoration: InputDecoration(
            hintText: 'Look for someone else...',
            border: OutlineInputBorder())),
    suggestionsCallback: (pattern) async {
      // print(pattern.toString());
      //return await BackendService.getSuggestions(pattern);
      return searchUsers();
    },
    itemBuilder: (context, suggestion) {
      return ListTile(
        leading: new Container(
            width: 40.0,
            height: 40.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(suggestion['profileImage'])))),
        title: Text(suggestion['name']),
        //subtitle: Text(suggestion['name']),
      );
    },
    onSuggestionSelected: (suggestion) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new Meet(suggestion['uid']),
      ));
    },
  );

  /*return Padding(
    padding: const EdgeInsets.all(15.0),
    child: TextField(
      onChanged: (e) {
        searchUsers();
      },
      decoration: new InputDecoration(
        prefixIcon: Icon(Icons.search),
        labelText: 'Search name ..',
        fillColor: Colors.grey[100],
        filled: true,
        contentPadding: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          bottom: 10.0,
        ),
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
      ),
      controller: controllerSearchName,
      keyboardType: TextInputType.text,
      style: new TextStyle(
        fontSize: 14.0,
        fontFamily: "Poppins",
        color: Colors.grey[600],
      ),
    ),
  );*/
}
