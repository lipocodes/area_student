import 'package:areastudent/data/constants.dart';
import 'package:areastudent/screens/chat_screen.dart';
import 'package:areastudent/tools/auth_service.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:areastudent/tools/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_post.dart';
import 'menu_groups.dart';
import 'meet.dart';
import 'package:areastudent/screens/images_in_large.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  MediaQueryData queryData;
  String uid = "";
  bool tempUid = false;
  List<String> profileImages = [];
  int indexProfileImage = 0;
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
  List<String> postsCreationCountry = [];
  List<String> postsCreationRegion = [];
  List<String> postsCreationSubRegion = [];
  List<String> postsCreationTime = [];
  List<String> postsText = [];
  List<List<String>> postsTags = [];
  List<List<String>> postsImages = [];
  List<File> postImageList = [];
  String gender = "";
  String textWarning = "";
  PageController pageController;
  TextEditingController controllerPostText = new TextEditingController();
  TextEditingController controllerAddTag = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String textTag1 = "Add tag";
  String tag1 = "123456789", tag2 = "123456789", tag3 = "123456789";
  int indexBottomBar = 0;
 

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      this.uid = uid;
      return uid;
    } catch (e) {
      this.tempUid = true;
      return "";
    }
  }

  Future<void> retrieveUserData() async {
    this.uid = await inputData();
    /*if (this.tempUid == true) {
      this.uid = "M0B7RtHW6zYOwkPhcqoHdigwEEs2";
      this.tempUid = true;
    }*/

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
      this.subregion = snapshot[0].data['subRegion'];
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

    final QuerySnapshot result = await Firestore.instance
        .collection('posts')
        .where('creatorUid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    this.postsId = [];
    this.postsCreatorUid = [];
    this.postsCreationCountry = [];
    this.postsCreationRegion = [];
    this.postsCreationSubRegion = [];
    this.postsCreationTime = [];
    this.postsText = [];
    this.postsTags = [];
    this.postsImages = [];

    for (int i = 0; i < snapshot.length; i++) {
      try {
        this.postsId.add(snapshot[i].data['postId'].toString());

        this.postsCreatorUid.add(snapshot[i].data['creatorUid'].toString());

        this
            .postsCreationCountry
            .add(snapshot[i].data['creationCountry'].toString());

        this
            .postsCreationRegion
            .add(snapshot[i].data['creationRegion'].toString());

        this
            .postsCreationSubRegion
            .add(snapshot[i].data['creationSubRegion'].toString());

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

    this.postsId = this.postsId.reversed.toList();
    this.postsCreatorUid = this.postsCreatorUid.reversed.toList();
    this.postsCreationCountry = this.postsCreationCountry.reversed.toList();
    this.postsCreationRegion = this.postsCreationRegion.reversed.toList();
    this.postsCreationSubRegion = this.postsCreationSubRegion.reversed.toList();
    this.postsCreationTime = this.postsCreationTime.reversed.toList();
    this.postsTags = this.postsTags.reversed.toList();
    this.postsText = this.postsText.reversed.toList();
    this.postsImages = this.postsImages.reversed.toList();

    setState(() {});
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

  double lengthTextBoxPost(int numWords) {
    print("ttttttttttttttttttt=  " + numWords.toString());
    double d = numWords / 5;
    double necessaryHeight = d * 20;
    return d * 10;
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
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Text(
                "Profile",
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
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //showDialogPostCreation();
            var res = await Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new CreatePost()));

            setState(() {
              retrievePostsCurrentUser();
            });
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: (int index) {
            setState(() {
              this.indexBottomBar = index;
            });

            if (this.indexBottomBar == 1) {
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new MenuGroups()));
            }
            else if (this.indexBottomBar == 3) { 
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new Meet(uid)));
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
        body: new Stack(
          children: [
            Positioned(
                top: 0,
                left: 0,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      profileImages.length > 0
                          ? SizedBox(
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
                            )
                          : Container(),
                    ],
                  ),
                )),
            Positioned(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.settings,
                          ),
                          iconSize: 35,
                          color: Colors.white,
                          onPressed: () {
                            onPressedSettingsButton();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.notifications_none,
                          ),
                          iconSize: 35,
                          color: Colors.white,
                          onPressed: () {
                            showSnackBar("In the future - Inbox will be here!",
                                scaffoldKey);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white70,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                              ),
                              iconSize: 35,
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  if (indexProfileImage > 0) {
                                    indexProfileImage = indexProfileImage - 1;
                                  } else {
                                    indexProfileImage =
                                        this.profileImages.length - 1;
                                  }
                                });
                              }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white70,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                            ),
                            iconSize: 35,
                            color: Colors.white,
                            onPressed: () {
                              if (indexProfileImage <
                                  this.profileImages.length - 1) {
                                setState(() {
                                  indexProfileImage = indexProfileImage + 1;
                                });
                              } else {
                                setState(() {
                                  indexProfileImage = 0;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 220,
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    userDetails(name, age, country, region, academicField,
                        aboutMe, numFollowers, numFollowings, context),
                    SizedBox(height: 50.0),
                    this.postsId.length > 0
                        ? SizedBox(
                            height: 400,
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Center(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: postsId.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0.0, right: 20.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                new Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    decoration: new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: new DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: new NetworkImage(
                                                                this.profileImages[
                                                                    0])))),
                                                SizedBox(width: 10),
                                                Text(
                                                    name +
                                                        "\n" +
                                                        postsCreationCountry[
                                                            index] +
                                                        "," +
                                                        postsCreationRegion[
                                                            index] +
                                                        "," +
                                                        postsCreationSubRegion[
                                                            index] +
                                                        "\n" +
                                                        timestampToTimeGap(
                                                            postsCreationTime[
                                                                index]),
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w800)),
                                                GestureDetector(
                                                    onTap: () async {
                                                      await firebaseMethod
                                                          .removePost(postsId,
                                                              postsId[index]);
                                                      retrievePostsCurrentUser();
                                                    },
                                                    child: Text(" X ",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                postsTags[index][0]
                                                            .toString() ==
                                                        '123456789'
                                                    ? Container()
                                                    : Text(
                                                        postsTags[index][0]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16.0)),
                                                SizedBox(width: 20.0),
                                                postsTags[index][1]
                                                            .toString() ==
                                                        '123456789'
                                                    ? Container()
                                                    : Text(
                                                        postsTags[index][1]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16.0)),
                                                SizedBox(width: 20.0),
                                                postsTags[index][2]
                                                            .toString() ==
                                                        '123456789'
                                                    ? Container()
                                                    : Text(
                                                        postsTags[index][2]
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 16.0)),
                                              ],
                                            ),
                                            SizedBox(height: 10.0),
                                            !postsImages[index]
                                                    .contains('123456789')
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            new CupertinoPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    new ImageInLarge(
                                                                      postsImages[
                                                                          index][0],
                                                                    )));
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            postsImages[index]
                                                                [0],
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          child: Center(
                                                              child:
                                                                  new CircularProgressIndicator()),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            new Icon(
                                                                Icons.error),
                                                        fadeInCurve:
                                                            Curves.easeIn,
                                                        fadeInDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(height: 10.0),
                                            postsImages[index].length > 1
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            new CupertinoPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    new ImageInLarge(
                                                                      postsImages[
                                                                          index][1],
                                                                    )));
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            postsImages[index]
                                                                [1],
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          child: Center(
                                                              child:
                                                                  new CircularProgressIndicator()),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            new Icon(
                                                                Icons.error),
                                                        fadeInCurve:
                                                            Curves.easeIn,
                                                        fadeInDuration:
                                                            Duration(
                                                                milliseconds:
                                                                    1000),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(height: 10.0),
                                            postsText[index].length > 0
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height: lengthTextBoxPost(
                                                        postsText[index]
                                                            .length),
                                                    child: Text(
                                                      postsText[index],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 16),
                                                      textAlign:
                                                          TextAlign.justify,
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
