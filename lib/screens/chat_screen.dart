import 'package:areastudent/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:areastudent/data/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  

  static const String id = 'chat_screen';
  String creatorUid;
  String recipientName;
  String textPost;
  String iconGroup;
  String profileImagePostCreator;
  ChatScreen(this.creatorUid, this.recipientName, this.textPost, this.iconGroup,
      this.profileImagePostCreator);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final List<Notification> notifications = [];
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  //final _firestore = Firestore.instance;
  String messageText;

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
     print('onMessage: $message');
      //Navigator.of(context).pushNamed(message['screen']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      //Navigator.of(context).pushNamed(message['screen']);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      //Navigator.of(context).pushNamed(message['screen']);
      return;
    });

    firebaseMessaging.getToken().then((token) {
      inputData().then((uid) {
        print('token: $token');
        Firestore.instance
            .collection('userData')
            .document(uid)
            .updateData({'pushToken': token});
      }).catchError((err) {
        Fluttertoast.showToast(msg: err.message.toString());
      });
    });
  }


    Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: null,
        actions: <Widget>[],
        title: Text(
          widget.recipientName,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black12),
                child: ListTile(
                  leading: Image.network(
                    widget.iconGroup,
                  ),
                  title: Text(
                    widget.textPost,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            widget.creatorUid.length != 0
                ? MessagesStream(
                    widget.creatorUid, widget.profileImagePostCreator)
                : Container(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                    ),
                    iconSize: 50,
                    color: Colors.black,
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'creationTime': new DateTime.now()
                            .millisecondsSinceEpoch
                            .toString(),
                        'recipientUid': widget.creatorUid,
                        'senderName': loggedInUser.displayName,
                        'senderUid': loggedInUser.uid,
                        'text': messageTextController.text,
                      });
                      messageTextController.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  String creatorUid;
  String profileImagePostCreator;
  MessagesStream(this.creatorUid, this.profileImagePostCreator);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['senderName'];
          final senderUid = message.data['senderUid'];
          final recipientUid = message.data['recipientUid'];
          final creationTime = message.data['creationTime'];
          final currentUser = loggedInUser.uid;

          bool yesNo = false;

          if (creatorUid == senderUid && loggedInUser.uid == recipientUid)
            yesNo = true;
          else if (creatorUid == recipientUid && loggedInUser.uid == senderUid)
            yesNo = true;
          if (yesNo == true) {
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == senderUid,
              profileImagePostCreator: profileImagePostCreator,
              creationTime: creationTime,
            );

            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.sender,
      this.text,
      this.isMe,
      this.profileImagePostCreator,
      this.creationTime});

  final String sender;
  final String text;
  final bool isMe;
  final String profileImagePostCreator;
  final String creationTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          profileImagePostCreator.length == 0
              ? CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                      NetworkImage('https://via.placeholder.com/150'),
                  backgroundColor: Colors.transparent,
                )
              : isMe
                  ? CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(loggedInUser.photoUrl),
                      backgroundColor: Colors.transparent,
                    )
                  : CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(profileImagePostCreator),
                      backgroundColor: Colors.transparent,
                    ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Text(
            timestampToTimeGap(creationTime),
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
