import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:areastudent/screens/images_in_large.dart';
import 'package:areastudent/tools/firebase_methods.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'menu_groups.dart';
import 'meet.dart';
import 'chats.dart';
import 'profile.dart';

class CommentsPosts extends StatefulWidget {
  String op = "";
  String postId = "";
  List<String> postsId;
  CommentsPosts(this.op, this.postId, this.postsId);
  @override
  _CommentsPostsState createState() => _CommentsPostsState();
}

class _CommentsPostsState extends State<CommentsPosts> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> listComments;
  List<String> postsCreatorUid = [];
  List<String> postsCreatorProfileImage = [];
  List<String> postsCreatorName = [];
  List<String> postsId = [];
  List<String> postsCreationCountry = [];
  List<String> postsCreationRegion = [];
  List<String> postsCreationSubRegion = [];
  List<String> postsCreationTime = [];
  List<String> postsTitle = [];
  List<String> postsText = [];
  List<List<String>> postsTags = [];
  List<List<String>> postsImages = [];
  List<String> profileImages = [];
  int indexBottomBar = 0;
  String uid;

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      this.uid = uid;
      return uid;
    } catch (e) {
      return "";
    }
  }

  retrieveComments() async {
    this.uid = await inputData();

    final QuerySnapshot result = await Firestore.instance
        .collection(
            widget.op == "createCommentsPostsGroups" ? 'postsGroups' : 'posts')
        .where('postId', isEqualTo: widget.postId)
        .getDocuments();

    final List<DocumentSnapshot> snapshot = result.documents;

    List list1 = snapshot[0].data['comments'];
    listComments = [];
    for (int i = 0; i < list1.length; i++) {
      listComments.add(list1[i].toString());
    }

    //take each comment and retrieve its data
    this.postsId = [];
    this.postsCreatorUid = [];
    this.postsCreatorProfileImage = [];
    this.postsCreatorName = [];
    this.postsCreationCountry = [];
    this.postsCreationRegion = [];
    this.postsCreationSubRegion = [];
    this.postsCreationTime = [];
    this.postsTitle = [];
    this.postsText = [];
    this.postsTags = [];
    this.postsImages = [];

    for (int i = 0; i < listComments.length; i++) {
      final QuerySnapshot result = await Firestore.instance
          .collection(widget.op == "createCommentsPostsGroups"
              ? 'commentsPostsGroups'
              : 'commentsPosts')
          .where('postId', isEqualTo: listComments[i])
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;
      this.postsId.add(snapshot[0].data['postId'].toString());
      this.postsCreatorUid.add(snapshot[0].data['creatorUid'].toString());
      this
          .postsCreationCountry
          .add(snapshot[0].data['creationCountry'].toString());
      this
          .postsCreationRegion
          .add(snapshot[0].data['creationRegion'].toString());
      this
          .postsCreationSubRegion
          .add(snapshot[0].data['creationSubRegion'].toString());
      this.postsCreationTime.add(snapshot[0].data['creationTime'].toString());
      this.postsTitle.add(snapshot[0].data['title'].toString());
      this.postsText.add(snapshot[0].data['text'].toString());

      List temp = snapshot[0].data['tags'];
      String tag1 = temp[0].toString();
      String tag2 = temp[1].toString();
      String tag3 = temp[2].toString();
      this.postsTags.add([tag1, tag2, tag3]);

      temp = snapshot[0].data['images'];
      String image1 = temp[0].toString();
      String image2 = temp[1].toString();
      this.postsImages.add([image1, image2]);
    }

    this.listComments = this.listComments.reversed.toList();
    this.postsId = this.postsId.reversed.toList();
    this.postsCreatorUid = this.postsCreatorUid.reversed.toList();
    this.postsCreationCountry = this.postsCreationCountry.reversed.toList();
    this.postsCreationRegion = this.postsCreationRegion.reversed.toList();
    this.postsCreationSubRegion = this.postsCreationSubRegion.reversed.toList();
    this.postsCreationTime = this.postsCreationTime.reversed.toList();
    this.postsTitle = this.postsTitle.reversed.toList();
    this.postsText = this.postsText.reversed.toList();
    this.postsTags = this.postsTags.reversed.toList();
    this.postsImages = this.postsImages.reversed.toList();

    for (int i = 0; i < postsCreatorUid.length; i++) {
      final QuerySnapshot result = await Firestore.instance
          .collection('userData')
          .where('uid', isEqualTo: postsCreatorUid[i])
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;
      this.postsCreatorName.add(snapshot[0].data['firstName'].toString() +
          "  " +
          snapshot[0].data['lastName'].toString());
      this
          .postsCreatorProfileImage
          .add(snapshot[0].data['profileImages'][0].toString());
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveComments();
  }

  double lengthTextBoxPost(int numChars) {
    if (numChars < 20) return 150.0;

    double numRows = numChars / 20;
    double necessaryHeight = numRows * 20;
    return necessaryHeight;
  }

  @override
  Widget build(BuildContext context) {
    if (listComments == null) return Container();

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
              "Comments",
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
        currentIndex: widget.op == "createCommentsPostsGroups" ? 1 : 0,
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
          } else if (this.indexBottomBar == 2) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Meet(this.uid)));
          } else if (this.indexBottomBar == 3) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Chats()));
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
      body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: listComments.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (this.postsCreatorProfileImage[index] != null) ...[
                      new Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      this.postsCreatorProfileImage[index])))),
                    ],
                    SizedBox(width: 10),
                    Text(
                        postsCreatorName[index] +
                            "\n" +
                            postsCreationCountry[index] +
                            "," +
                            postsCreationRegion[index] +
                            "," +
                            postsCreationSubRegion[index] +
                            "\n" +
                            timestampToTimeGap(postsCreationTime[index]),
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w800)),
                    GestureDetector(
                        onTap: () async {
                          await firebaseMethod.removeCommentPost(
                              widget.op == "createCommentsPostsGroups"
                                  ? "createCommentsPostsGroups"
                                  : "createCommentsPosts",
                              listComments[index],
                              listComments,
                              widget.postId);
                          retrieveComments();
                        },
                        child: Text(" X ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500))),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    postsTags[index][0].toString() == '123456789'
                        ? Container()
                        : Text(postsTags[index][0].toString(),
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.0)),
                    SizedBox(width: 20.0),
                    postsTags[index][1].toString() == '123456789'
                        ? Container()
                        : Text(postsTags[index][1].toString(),
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.0)),
                    SizedBox(width: 20.0),
                    postsTags[index][2].toString() == '123456789'
                        ? Container()
                        : Text(postsTags[index][2].toString(),
                            style:
                                TextStyle(color: Colors.blue, fontSize: 16.0)),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.0),
                    postsImages[index][0] != '123456789'
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.7,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            new ImageInLarge(
                                              postsImages[index][0],
                                            )));
                              },
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
                            ),
                          )
                        : Container(),
                    SizedBox(height: 10.0),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.0),
                    postsImages[index][1] != '123456789'
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.width * 0.7,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            new ImageInLarge(
                                              postsImages[index][1],
                                            )));
                              },
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
                            ),
                          )
                        : Container(),
                  ],
                ),
               
                postsTitle[index] != null
                    ? Text(
                        postsTitle[index],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      )
                    : Container(),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    postsText[index] != null
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: lengthTextBoxPost(postsText[index].length),
                            child: Column(
                              children: [
                                Text(
                                  postsText[index],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ],
            );
          }),
    );
  }
}
