import 'package:areastudent/screens/create_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:areastudent/tools/widgets.dart';
import 'create_post_group.dart';
import 'chat_screen.dart';
import 'meet.dart';
import 'package:areastudent/screens/images_in_large.dart';
import 'chats.dart';
import 'package:areastudent/tools/firebase_methods.dart';
import 'comments_posts.dart';
import 'create_post.dart';
import 'notifications.dart';

class Group extends StatefulWidget {
  String nameGroup = "";
  String iconGroup = "";
  Group(this.nameGroup, this.iconGroup);

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  FirebaseMethods firebaseMethods = new FirebaseMethods();
  String uid = "";
  int indexBottomBar = 0;
  List<String> postsName = [];
  List<List<String>> postsLikes = [];
  List<List<String>> postsComments = [];
  List<String> postsId = [];
  List<String> membersGroup = [];
  List<String> creationTime = [];
  List<String> creatorName = [];
  List<String> creatorUid = [];
  List<List<String>> images = [];
  List<String> profileImage = [];
  List<String> text = [];
  String textFollowButton = "Follow";

  bool isFollowedByMe = false;

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      return uid;
    } catch (e) {
      return "";
    }
  }

  Future retrievePostsNames() async {
    uid = await inputData();
    final QuerySnapshot result = await Firestore.instance
        .collection('groups')
        .where('name', isEqualTo: widget.nameGroup)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    List<dynamic> str1 = snapshot[0].data['posts'];
    List<String> str2 = [];
    for (int i = 0; i < str1.length; i++) {
      str2.add(str1[i].toString());
    }
    this.postsName = str2;
    //this.postsName = this.postsName.reversed.toList();

    str1 = snapshot[0].data['members'];
    str2 = [];
    for (int i = 0; i < str1.length; i++) {
      str2.add(str1[i].toString());
    }
    this.membersGroup = str2;
    if (this.membersGroup.contains(uid))
      this.textFollowButton = "Unfollow";
    else
      this.textFollowButton = "Follow";
  }

  Future retrievePostsContents() async {
    this.postsId = [];
    this.creationTime = [];
    this.creatorName = [];
    this.creatorUid = [];
    this.profileImage = [];
    this.text = [];
    this.images = [];

    //save in local memory the time of my last visit
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int timeNow = new DateTime.now().millisecondsSinceEpoch + 2 * 60 * 1000;
    String whichGroup = widget.nameGroup;
    await prefs.setInt(whichGroup, timeNow);

    final QuerySnapshot result = await Firestore.instance
        .collection('postsGroups')
        //.where('id', isEqualTo: postsName[0])
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    for (int i = 0; i < snapshot.length; i++) {
      if (postsName.contains(snapshot[i].data['postId'])) {
        postsId.add(snapshot[i].data['postId']);

        creationTime.add(snapshot[i].data['creationTime']);
        creatorName.add(snapshot[i].data['creatorName']);
        creatorUid.add(snapshot[i].data['creatorUid']);
        profileImage.add(snapshot[i].data['profileImage']);
        text.add(snapshot[i].data['text']);
        List<dynamic> str1 = snapshot[i].data['images'];
        List<String> str2 = [];
        for (int j = 0; j < str1.length; j++) {
          str2.add(str1[j]);
        }
        this.images.add(str2);

        List temp = snapshot[i].data['likes'];
        List<String> str14 = [];
        for (int i = 0; i < temp.length; i++) {
          str14.add(temp[i].toString());
        }
        this.postsLikes.add(str14);

        temp = snapshot[i].data['comments'];

        List<String> str16 = [];
        bool visitedLoop = false;
        //this.postsComments = [];
        for (int i = 0; i < temp.length; i++) {
          str16.add(temp[i].toString());

          visitedLoop = true;
        }
        if (visitedLoop == true) {
          this.postsComments.add(str16);
        } else {
          this.postsComments.add([]);
        }
      }
    }

    this.postsName = this.postsName.reversed.toList();
    this.postsId = this.postsId.reversed.toList();
    this.creationTime = this.creationTime.reversed.toList();
    this.creatorName = this.creatorName.reversed.toList();
    this.creatorUid = this.creatorUid.reversed.toList();
    this.profileImage = this.profileImage.reversed.toList();
    this.text = this.text.reversed.toList();
    this.images = this.images.reversed.toList();

    setState(() {});
  }

  Future addMeMembersGroup() async {
    try {
      String uid = await inputData();
      if (!this.membersGroup.contains(uid)) {
        this.membersGroup.add(uid);
        await Firestore.instance
            .collection("groups")
            .document(widget.nameGroup)
            .updateData({'members': this.membersGroup});
        this.textFollowButton = "Unfollow";
        setState(() {});
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeee addMeMembersGroup");
    }
  }

  Future removeMeMembersGroup() async {
    try {
      String uid = await inputData();
      if (this.membersGroup.contains(uid)) {
        this.membersGroup.remove(uid);
        await Firestore.instance
            .collection("groups")
            .document(widget.nameGroup)
            .updateData({'members': this.membersGroup});
        this.textFollowButton = "Follow";
        setState(() {});
      }
    } catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeee removeMeMembersGroup()");
    }
  }

  likePost(int index) async {
    bool addOrRemove = false;

    if (didILikeThisPostAlready(index) == false) {
      postsLikes[index].add(this.uid);
      addOrRemove = true;
    } else {
      postsLikes[index].remove(this.uid);
      addOrRemove = false;
    }

    await firebaseMethods.updateLikeListPost(addOrRemove, creatorUid[index],
        "postsGroups", postsId[index], postsLikes[index]);
    setState(() {});
  }

  bool didILikeThisPostAlready(index) {
    if (postsLikes[index].contains(this.uid))
      return true;
    else
      return false;
  }

  createNewPost(String op, String existingPostId) async {
    var res = await Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new CreatePost(op, existingPostId)));

    setState(() {
      retrievePostsContents();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.retrievePostsNames().whenComplete(() {
      this.retrievePostsContents().whenComplete(() {});
    });

    _scrollController.addListener(() {
      var triggerFetchMoreSize =
          0.9 * _scrollController.position.maxScrollExtent;

      if (_scrollController.position.pixels > triggerFetchMoreSize) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.postsName == null) return Container();

   

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Text(
              widget.nameGroup,
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
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Notifications()));
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(new CupertinoPageRoute(
              builder: (BuildContext context) =>
                  new CreatePostGroup(widget.nameGroup)));
          this.retrievePostsNames().whenComplete(() {
            this.retrievePostsContents().whenComplete(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // this will be set when a new tab is tapped
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
          } else if (this.indexBottomBar == 2) {

             Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => new Meet(this.uid),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 2000),
                ),
              );

            //Navigator.of(context).push(new CupertinoPageRoute(
              //  builder: (BuildContext context) => new Meet(this.uid)));
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
        child: Column(
          children: [
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    if (this.textFollowButton == "Follow")
                      this.addMeMembersGroup();
                    else
                      this.removeMeMembersGroup();
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
                    child: new Text(textFollowButton,
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Column(
              children: [
                ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: true,
                    //scrollDirection: Axis.vertical,
                    itemCount: postsName.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          child: Column(
                            children: [
                              this.creatorUid[index] == this.uid
                                  ? GestureDetector(
                                      onTap: () async {
                                        await firebaseMethod.removePostGroup(
                                            this.postsName[index],
                                            widget.nameGroup);
                                        await retrievePostsNames();
                                        await retrievePostsContents();
                                      },
                                      child: Text(" X ",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500)))
                                  : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  this.profileImage[index].length != 0
                                      ? GestureDetector(
                                          onTap: () {
                                               Navigator.of(context).push(
                                            new CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new Meet(creatorUid[index],
                                                            )));
                                          },
                                          child: new Container(
                                              width: 50.0,
                                              height: 50.0,
                                              decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: new NetworkImage(
                                                          profileImage[
                                                              index])))),
                                        )
                                      : Container(),
                                  this.creationTime[index].length != 0
                                      ? Text(
                                          creatorName[index] +
                                              "\n" +
                                              timestampToTimeGap(
                                                  creationTime[index]),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700))
                                      : Container(),
                                  GestureDetector(
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                            new CupertinoPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        new ChatScreen(
                                                            creatorUid[index]
                                                                .toString(),
                                                            creatorName[index]
                                                                .toString(),
                                                            text[index]
                                                                .toString(),
                                                            widget.iconGroup,
                                                            profileImage[index]
                                                                .toString())));
                                      },
                                      child: this.creatorUid[index] != this.uid
                                          ? Icon(Icons.chat_bubble_outline)
                                          : Container()),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              this.text[index].length != 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        text[index],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  : Container(),
                              this.images[index].length > 0 &&
                                      this.images[index][0].length != 0
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              new CupertinoPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          new ImageInLarge(
                                                              images[index]
                                                                  [0])));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: images[index][0],
                                          placeholder: (context, url) =>
                                              Container(
                                            child: Center(
                                                child:
                                                    new CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                          fadeInCurve: Curves.easeIn,
                                          fadeInDuration:
                                              Duration(milliseconds: 1000),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(height: 10),
                              this.images[index].length > 1 &&
                                      this.images[index][1].length != 0
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              new CupertinoPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          new ImageInLarge(
                                                              images[index]
                                                                  [1])));
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: images[index][1],
                                          placeholder: (context, url) =>
                                              Container(
                                            child: Center(
                                                child:
                                                    new CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                          fadeInCurve: Curves.easeIn,
                                          fadeInDuration:
                                              Duration(milliseconds: 1000),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.thumb_up),
                                    iconSize: 30,
                                    color:
                                        didILikeThisPostAlready(index) == true
                                            ? Colors.blueAccent
                                            : Colors.grey,
                                    splashColor: Colors.purple,
                                    onPressed: () {
                                      likePost(index);
                                    },
                                  ),
                                  this.postsLikes[index].length != null &&
                                          this.postsLikes[index].length != 0
                                      ? Text(
                                          this
                                              .postsLikes[index]
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.blueAccent))
                                      : Text("0",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.blueAccent)),
                                  SizedBox(width: 50.0),
                                  IconButton(
                                    icon: Icon(
                                      Icons.chat_bubble_outline,
                                    ),
                                    iconSize: 30,
                                    color: Colors.blueAccent,
                                    splashColor: Colors.purple,
                                    onPressed: () async {
                                      await Navigator.of(context).push(
                                          new CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  new CommentsPosts(
                                                      "createCommentsPostsGroups",
                                                      postsId[index],
                                                      postsComments[index])));

                                      setState(() {});
                                    },
                                  ),
                                  this.postsComments[index].length != null &&
                                          this.postsComments[index].length != 0
                                      ? Text(
                                          this
                                              .postsComments[index]
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.blueAccent))
                                      : Text("0",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.blueAccent)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FlatButton(
                                    color: Colors.black26,
                                    textColor: Colors.white,
                                    padding: EdgeInsets.all(8.0),
                                    splashColor: Colors.blueAccent,
                                    onPressed: () async{
                                      await createNewPost("createCommentPostGroups",
                                          postsId[index].toString());

                                      //retrievePostsContents();

                                    },
                                    child: Text(
                                      "Comment",
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
