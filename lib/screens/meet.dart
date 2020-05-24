import 'package:areastudent/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/cupertino.dart';
import 'menu_groups.dart';
import 'profile.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'contact.dart';

String targetUidd;
String myUid;
String textBlockUser = "";

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
        currentIndex: 3,
        onTap: (int index) {
          setState(() {
            this.indexBottomBar = index;
          });

          if (this.indexBottomBar == 0) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Profile()));
          } else if (this.indexBottomBar == 1) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new MenuGroups()));
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
      body: Column(children: [
        searchUserBox(context),
        PersonalCard(),
      ]),
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
  String textFollowButton = "Follow";
  String textBlockUser = "";
  followThisUser() async {
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

    followers.add(this.uid);
    try {
      String uid = await inputData();
      await Firestore.instance
          .collection("userData")
          .document(this.uid)
          .updateData({'followers': followers});

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
    followers.remove(this.uid);
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
  }

  retrieveUserData() async {
    //this.uid = await inputData();
    this.uid = "AvcNcYj0yWRxnPZaQXj88oelrLB3";

    if (targetUidd.length > 10) {
      this.uid = targetUidd;
    } else {
      this.uid = "AvcNcYj0yWRxnPZaQXj88oelrLB3";
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

      this.name =
          snapshot[0].data['firstName'] + "  " + snapshot[0].data['lastName'];
      this.gender = snapshot[0].data['gender'];
      this.country = snapshot[0].data['country'];
      this.region = snapshot[0].data['region'];
      this.subregion = snapshot[0].data['subRegion'];
      this.locality = snapshot[0].data['locality'];
      this.academicField = snapshot[0].data['academicField'];
      this.aboutMe = snapshot[0].data['aboutMe'];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    if (this.uid == null || this.uid.length == 0) return Container();

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
                ),
              ),
            ),
            Positioned(
              top: 110,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
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
            ),
          ],
        ),
        userDetails(this.name, this.age.toString(), this.country, this.region,
            this.academicField, this.aboutMe, -1, -1, context),
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
                            this.profileImages[0].toString())));
                  },
                  child: Icon(Icons.chat_bubble_outline, size: 45)),
              GestureDetector(
                  onTap: () async {
                    showDialogSettings(context);
                  },
                  child: Icon(Icons.settings, size: 45)),
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
          height: 100,
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
  if(str1==null)  str1 = [];

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
    String uid = user.uid.toString();
    return uid;
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
    String searchText = controllerSearchName.text;
    searchText = convertUpperCase(searchText);

    if (searchText.length > 1 &&
        searchText.substring(searchText.length - 1) == " ") {
      var input = searchText;
      var str = input.split(" ");

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
              fontSize: 18,
              color: Colors.black,
            ),
        decoration: InputDecoration(border: OutlineInputBorder())),
    suggestionsCallback: (pattern) async {
      //print(pattern.toString());
      //return await BackendService.getSuggestions(pattern);
      return searchUsers();
    },
    itemBuilder: (context, suggestion) {
      return ListTile(
        //leading: Icon(Icons.shopping_cart),
        //title: Text(suggestion['profileImage']),
        subtitle: Text(suggestion['name']),
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
