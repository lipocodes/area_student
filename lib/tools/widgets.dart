import 'package:flutter/material.dart';
import 'package:areastudent/data/constants.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

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

Widget largeProfileImage(BuildContext context, List<String> profileImages) {
  return Container(
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        profileImages.length > 0
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
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

Widget buttonsOnTopProfileImage() {
  return Column(
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
              onPressed: () {},
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
              onPressed: () {},
            ),
          ),
        ],
      ),
      SizedBox(height: 20.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              iconSize: 45,
              color: Colors.white,
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward,
              ),
              iconSize: 45,
              color: Colors.white,
              onPressed: () {},
            ),
          ),
        ],
      ),
    ],
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
    color: Colors.white70,
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
                    Text(country + ",",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)),
                    Text(region,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)),
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
              Text("      " + numFollowers.toString() + "\nFollowers",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              SizedBox(width: 20),
              Text("      " + numFollowings.toString() + "\nFollowing",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
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
    List<String> postsCreationLatitude,
    List<String> postsCreationLongitude,
    List<List<String>> postsTags,
    List<String> postsText,
    List<List<String>> postsImages) {
  return SizedBox(
    height: 100,
    child: ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: postsId.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                          coordinatesToLocation(postsCreationLatitude[index],
                              postsCreationLongitude[index]) +
                          "   " +
                          timestampToTimeGap(postsCreationTime[index]),
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w800)),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  postsTags[index][0].toString() != null
                      ? Text(postsTags[index][0].toString(),
                          style: TextStyle(color: Colors.blue, fontSize: 16.0))
                      : Container(),
                  SizedBox(width: 20.0),
                  postsTags[index][1].toString() != null
                      ? Text(postsTags[index][1].toString(),
                          style: TextStyle(color: Colors.blue, fontSize: 16.0))
                      : Container(),
                  SizedBox(width: 20.0),
                  postsTags[index][2].toString() != null
                      ? Text(postsTags[index][2].toString(),
                          style: TextStyle(color: Colors.blue, fontSize: 16.0))
                      : Container(),
                ],
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.4,
                child: CachedNetworkImage(
                  imageUrl: postsImages[index][0],
                  placeholder: (context, url) => Container(
                    child: Center(child: new CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: Duration(milliseconds: 1000),
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 10.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 200,
                child: Text(
                  "asdasdasdasdasd",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

String coordinatesToLocation(String latitude, String longitude) {
  return "Seoul";
}

String timestampToTimeGap(String timestamp) {
  return "20 days ago";
}
