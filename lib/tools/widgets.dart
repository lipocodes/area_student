import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:areastudent/data/constants.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:areastudent/screens/followers.dart';
import 'package:areastudent/screens/following.dart';
import 'package:geolocator/geolocator.dart';

int indexLargeProfileImage = 0;

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
            height: 150.0,
            child: new ListView.builder(
                itemCount: imageList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return new Padding(
                    padding: new EdgeInsets.only(left: 3.0, right: 3.0),
                    child: new Stack(
                      children: <Widget>[
                        new Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                              color: Colors.grey.withAlpha(100),
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(15.0)),
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: new FileImage(imageList[index]))),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(5.0),
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

switchLargeProfileImage(String newProfileImage) {}

Widget largeProfileImage(BuildContext context, List<String> profileImages) {
  return Container(
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        profileImages.length > 0
            ? SizedBox(
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height * 0.6,
                child: CachedNetworkImage(
                  imageUrl: profileImages[0],
                  placeholder: (context, url) => Container(
                    child: Center(child: new CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: Duration(milliseconds: 1000),
                  fit: BoxFit.fill,
                ),
              )
            : Container(),
      ],
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
  return Container(
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
                  name,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  age,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
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
                    country!=null? Text(country + ",",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)) : Text("NA"),
                    region!=null? Text(region,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400))  :Text(""),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.school),
                    Text(academicField,
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
              aboutMe,
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
                child: Text("      " + numFollowers.toString() + "\nFollowers",
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
                child: Text("      " + numFollowings.toString() + "\nFollowing",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget listStoriesProfileScreen(
    BuildContext context,
    List<String> postsId,
    String name,
    List<String> profileImage,
    List<String> postsCreationTime,
    List<String> postsCreationCountry,
    List<String> postsCreationRegion,
    List<String> postsCreationSubRegion,
    List<List<String>> postsTags,
    List<String> postsText,
    List<List<String>> postsImages) {


  return Container(
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
              padding: const EdgeInsets.only(left: 0.0, right: 20.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(profileImage[0])))),
                      SizedBox(width: 10),
                      Text(
                          name +
                              "\n" +
                              postsCreationCountry[index] +
                              "," +
                              postsCreationRegion[index] +
                              "," +
                              postsCreationSubRegion[index] + "\n" + timestampToTimeGap(postsCreationTime[index]),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w800)),
                    ],
                  ),
             
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      postsTags[index][0].toString() != null
                          ? Text(postsTags[index][0].toString(),
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16.0))
                          : Container(),
                      SizedBox(width: 20.0),
                      postsTags[index][1].toString() != null
                          ? Text(postsTags[index][1].toString(),
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16.0))
                          : Container(),
                      SizedBox(width: 20.0),
                      postsTags[index][2].toString() != null
                          ? Text(postsTags[index][2].toString(),
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16.0))
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  postsImages[index].length>0
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: CachedNetworkImage(
                            imageUrl: postsImages[index][0],
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
                  SizedBox(height: 10.0),
                  postsImages[index].length>1
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: CachedNetworkImage(
                            imageUrl: postsImages[index][1],
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
                  SizedBox(height: 10.0),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 500,
                    child: Text( 
                      postsText[index],
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height:20.0),
                  Divider(thickness: 10,),
                ],
              ),
            );
          },
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
    return (gap / (60 * 1000)).toString() + " minutes ago";
  } else if (gap < 24 * 60 * 60 * 1000) {    
    //if less than 24 hours
    int remainder = gap % (60 * 60 * 1000);
    gap = gap - remainder;
    return (gap / (60 * 60 * 1000)).toString() + " hours ago";
  } else {
    //if more than 24 hours
    int remainder = gap % (24 * 60 * 60 * 1000);
    gap = gap - remainder;
    return (gap / (24 * 60 * 60 * 1000)).toString() + " days ago";
  }
}
