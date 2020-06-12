import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:areastudent/data/constants.dart';
import 'dart:io';

import 'package:areastudent/screens/followers.dart';
import 'package:areastudent/screens/following.dart';
import 'package:geolocator/geolocator.dart';
import 'package:areastudent/tools/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:areastudent/screens/meet.dart';
import 'package:areastudent/screens/comments_posts.dart';


int indexLargeProfileImage = 0;
FirebaseMethods firebaseMethod = new FirebaseMethods();
Firestore firestore = Firestore.instance;
List<String> notificationOriginalPostUid = [];
List<String> notificationIcon = [];
List<String> notificationCreationTime = [];
List<String> notificationCreatorName = [];
List<String> notificationOperation = [];
List<String> notificationLink = [];
String myUid;
String myProfileImage;
String myName;


Widget signupInputBox(
    {String labelText,
    TextEditingController controller,
    TextInputType textInputType}) {
  return new TextFormField(
    decoration: new InputDecoration(
      labelText: labelText,
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
    controller: controller,
    keyboardType: textInputType,
    style: new TextStyle(
      fontSize: 14.0,
      fontFamily: "Poppins",
      color: Colors.grey[600],
    ),
  );
}

Widget signupButton({int whichScreen}) {
  return RaisedButton(
    onPressed: null, //the click event is impolemented in the screen classes
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
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      padding: const EdgeInsets.fromLTRB(110, 12, 110, 12),
      child: new Text(whichScreen == 4 ? screen4Signup : screen2Signup,
          style: TextStyle(fontSize: 20, color: Colors.white)),
    ),
  );
}

Widget postCreationButton({int whichScreen}) {
  return RaisedButton(
    onPressed: null, //the click event is impolemented in the screen classes
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
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      padding: const EdgeInsets.fromLTRB(80, 10, 80, 10),
      child: Text(screen13CreatePost,
          style: TextStyle(fontSize: 20, color: Colors.white)),
    ),
  );
}

Widget sendVerificationCodeButton({int whichScreen}) {
  return RaisedButton(
    onPressed: null, //the click event is impolemented in the screen classes
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
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      padding: const EdgeInsets.fromLTRB(110, 12, 110, 12),
      child: new Text(screen8AuthenticationButton,
          style: TextStyle(fontSize: 20, color: Colors.white)),
    ),
  );
}

Widget multiImagePickerList(
    {List<File> imageList, VoidCallback removeNewImage(int position)}) {
  return new Padding(
    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
    child: imageList == null || imageList.length == 0
        ? new Container()
        : new SizedBox(
            height: 80.0,
            child: new ListView.builder(
                itemCount: imageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return new Padding(
                    padding: new EdgeInsets.only(left: 3.0, right: 3.0),
                    child: new Stack(
                      children: <Widget>[
                        new Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: new BoxDecoration(
                              color: Colors.grey.withAlpha(100),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(40.0)),
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new FileImage(imageList[index]))),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: new CircleAvatar(
                            backgroundColor: Colors.red[600],
                            child: new IconButton(
                                icon: new Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  removeNewImage(index);
                                }),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
  );
}

Widget userDetails(
    String name,
    String age,
    String country,
    String region,
    String academicField,
    String aboutMe,
    int numFollowers,
    int numFollowings,
    BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      color: Colors.grey[200],
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    name != null ? name : "",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Text(
                    age != null ? age : "",
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on),
                      country != null
                          ? Text(country + ",",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400))
                          : Text("NA"),
                      region != null
                          ? Text(region,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400))
                          : Text(""),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.school),
                      Text(academicField != null ? academicField : "",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              child: Text(
                aboutMe != null ? aboutMe : "",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new Followers()));
                  },
                  child: Text(
                      "      " + numFollowers.toString() + "\nFollowers",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
                SizedBox(width: 20.0),
                Container(
                  width: 2,
                  height: 50,
                  color: Colors.grey,
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new Followings()));
                  },
                  child: Text(
                      "      " + numFollowings.toString() + "\nFollowing",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future coordinatesToLocation(String latitude, String longitude) async {
  List<Placemark> newPlace = await Geolocator().placemarkFromCoordinates(
      double.parse(latitude), double.parse(longitude));
  Placemark placeMark = newPlace[0];
  String locality = placeMark.locality;
  String administrativeArea = placeMark.administrativeArea;
  String subAdministrativeArea = placeMark.subAdministrativeArea;
  String country = placeMark.country;

  return country + "," + administrativeArea;
}

Future<double> distanceBetweenPoints(String latitude, String longitude) async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  double myLatitude = position.latitude;
  double myLongitude = position.longitude;
  double distanceInMeters = await Geolocator().distanceBetween(
      myLatitude, myLongitude, double.parse(latitude), double.parse(longitude));
  //print("xxxxxxxxxxxxxxxxxxxxx= " + (distanceInMeters / 1000).toString());
  return distanceInMeters / 1000;
}

String timestampToTimeGap(String timestamp) {
  int timeNow = new DateTime.now().millisecondsSinceEpoch;
  int postCreationMilliseconds = int.parse(timestamp);
  int gap = timeNow - postCreationMilliseconds;

  if (gap < 60 * 1000)
    return "Just now"; //less than 60 seconds ago
  else if (gap < 60 * 60 * 1000) {
    //if less than 60 minutes
    int remainder = gap % (60 * 1000);
    gap = gap - remainder;
    return (gap / (60 * 1000)).round().toString() + " mins";
  } else if (gap < 24 * 60 * 60 * 1000) {
    //if less than 24 hours
    int remainder = gap % (60 * 60 * 1000);
    gap = gap - remainder;
    return (gap / (60 * 60 * 1000)).round().toString() + " hours";
  } else {
    //if more than 24 hours
    int remainder = gap % (24 * 60 * 60 * 1000);
    gap = gap - remainder;
    return (gap / (24 * 60 * 60 * 1000)).round().toString() + " days";
  }
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






  onTapNotification(int index, context) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: myUid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    List str1 = snapshot[0].data['notifications'];
    List<String> notifications = [];
    if (str1 == null) str1 = [];

    for (int i = 0; i < str1.length; i++) {
      notifications.add(str1[i].toString());
    }

    for (int h = 0; h < notifications.length; h++) {
      if (notifications[h]
          .contains(notificationCreationTime[index].toString())) {
        notifications.removeAt(h);
      }
    }

    try {
      String uid = await inputData();
      await Firestore.instance
          .collection("userData")
          .document(myUid)
          .updateData({'notifications': notifications});
    } catch (e) {}

    if (notificationOperation[index] == "Comment on Post") {
      final QuerySnapshot result = await Firestore.instance
          .collection('posts')
          .where('postId', isEqualTo: notificationOriginalPostUid[index])
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;
      List temp = snapshot[0].data['comments'];
      List<String> comments = [];
      for (int i = 0; i < temp.length; i++) {
        comments.add(temp[i].toString());
      }

      await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new CommentsPosts(
              "createCommentsPosts",
              notificationOriginalPostUid[index],
              comments)));
      retrieveNotifications();
    } else if (notificationOperation[index] == "Comment on Post in Group") {
      final QuerySnapshot result = await Firestore.instance
          .collection('postsGroups')
          .where('postId', isEqualTo: notificationOriginalPostUid[index])
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;
      List temp = snapshot[0].data['comments'];
      List<String> comments = [];
      for (int i = 0; i < temp.length; i++) {
        comments.add(temp[i].toString());
      }

      await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) => new CommentsPosts(
              "createCommentsPostsGroups",
              notificationOriginalPostUid[index],
              comments)));
      retrieveNotifications();
    } else if (notificationOperation[index] == "Liked Post") {
      await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) =>
              new Meet(notificationOriginalPostUid[index])));
      retrieveNotifications();
    } else if (notificationOperation[index] == "Liked Post in Group") {
      await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) =>
              new Meet(notificationOriginalPostUid[index])));
      retrieveNotifications();
    } else if (notificationOperation[index] == "Followed You") {
      await Navigator.of(context).push(new CupertinoPageRoute(
          builder: (BuildContext context) =>
              new Meet(notificationOriginalPostUid[index])));
    }

    Navigator.of(context).pop();
  }




   Future retrieveNotifications() async {
    notificationOriginalPostUid = [];
    notificationIcon = [];
    notificationCreationTime = [];
    notificationCreatorName = [];
    notificationOperation = [];
    notificationLink = [];

    myUid = await inputData();

    final QuerySnapshot result = await firestore
        .collection("userData")
        .where('uid', isEqualTo: myUid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    List<dynamic> str1 = snapshot[0].data['notifications'];

    for (int i = 0; i < str1.length; i++) {
      var not = str1[i].toString();
      var notification = not.split("^^^");
      notificationOriginalPostUid.add(notification[0]);
      notificationIcon.add(notification[1]);
      notificationCreatorName.add(notification[2]);
      notificationCreationTime.add(notification[3]);
      notificationOperation.add(notification[4]);
      notificationLink.add(notification[5]);
    }
  }




Widget notifications() {
  return ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                          ),
                          itemCount: notificationIcon.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                onTapNotification(index,context);
                              },
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  new Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                              fit: BoxFit.fill,
                                              image: new NetworkImage(
                                                  notificationIcon[index])))),
                                  SizedBox(width: 10.0),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(notificationCreatorName[index],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800)),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(notificationOperation[index],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.0),
                                  SizedBox(
                                    width: 40.0,
                                    child: Text(
                                      timestampToTimeGap(
                                          notificationCreationTime[index]),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
}
