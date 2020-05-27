import 'package:flutter/material.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/cupertino.dart';
import 'menu_groups.dart';
import 'meet.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int indexBottomBar = 0;
  String uid = "";
  List<String> list1SenderUid = [];
  List<String> list1RecipientUid = [];
  List<String> list1CreationTime = [];
  List<String> list1Text = [];
  List<String> list1Voice = [];
  List<String> list1File = [];
  List<String> list1Image = [];

  List<String> list2SenderUid = [];
  List<String> list2RecipientUid = [];
  List<String> list2CreationTime = [];
  List<String> list2Text = [];
  List<String> list2Voice = [];
  List<String> list2File = [];
  List<String> list2Image = [];

  List<String> mergedListSenderUid = [];
  List<String> mergedListRecipientUid = [];
  List<String> mergedListCreationTime = [];
  List<String> mergedListText = [];
  List<String> mergedListVoice = [];
  List<String> mergedListFile = [];
  List<String> mergedListImage = [];

  List<String> readListSenderUid = [];
  List<String> readListRecipientUid = [];
  List<String> readListCreationTime = [];
  List<String> readListText = [];
  List<String> readListVoice = [];
  List<String> readListFile = [];
  List<String> readListImage = [];

  List<String> unreadListSenderUid = [];
  List<String> unreadListRecipientUid = [];
  List<String> unreadListCreationTime = [];
  List<String> unreadListText = [];
  List<String> unreadListVoice = [];
  List<String> unreadListFile = [];
  List<String> unreadListImage = [];

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      return uid;
    } catch (e) {
      return "";
    }
  }

  getMyUid() async {
    this.uid = await inputData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyUid();
    createChatList();
  }

  //retrieve all the data needed for showing the different chats, arranged by read/unread & time of last message
  createChatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final QuerySnapshot result1 = await Firestore.instance
        .collection('messages')
        .where('senderUid', isEqualTo: 'UXlUwUGhs3dwYp6m7h6k9kJHlOJ3')
        .getDocuments();
    final List<DocumentSnapshot> snapshot1 = result1.documents;

    for (int i = 0; i < snapshot1.length; i++) {
      list1CreationTime.add(snapshot1[i].data['creationTime']);
      list1SenderUid.add(snapshot1[i].data['senderUid']);
      list1RecipientUid.add(snapshot1[i].data['recipientUid']);
      list1Text.add(snapshot1[i].data['text']);
      list1Voice.add(snapshot1[i].data['attachedVoiceRecording']);
      list1File.add(snapshot1[i].data['attachedFile']);
      list1Image.add(snapshot1[i].data['attachedAttachedImage']);
    }

    final QuerySnapshot result2 = await Firestore.instance
        .collection('messages')
        .where('recipientUid', isEqualTo: 'UXlUwUGhs3dwYp6m7h6k9kJHlOJ3')
        .getDocuments();
    final List<DocumentSnapshot> snapshot2 = result2.documents;

    for (int i = 0; i < snapshot2.length; i++) {
      list2CreationTime.add(snapshot2[i].data['creationTime']);
      list2SenderUid.add(snapshot2[i].data['senderUid']);
      list2RecipientUid.add(snapshot2[i].data['recipientUid']);
      list2Text.add(snapshot2[i].data['text']);
      list2Voice.add(snapshot2[i].data['attachedVoiceRecording']);
      list2File.add(snapshot2[i].data['attachedFile']);
      list2Image.add(snapshot2[i].data['attachedAttachedImage']);
    }

    //merge the 2 lists into a single list
    for (int i = 0; i < list1CreationTime.length; i++) {
      mergedListCreationTime.add(list1CreationTime[i]);
    }
    for (int i = 0; i < list2CreationTime.length; i++) {
      mergedListCreationTime.add(list2CreationTime[i]);
    }

    for (int i = 0; i < list1SenderUid.length; i++) {
      mergedListSenderUid.add(list1SenderUid[i]);
    }
    for (int i = 0; i < list2SenderUid.length; i++) {
      mergedListSenderUid.add(list2SenderUid[i]);
    }

    for (int i = 0; i < list1RecipientUid.length; i++) {
      mergedListRecipientUid.add(list1RecipientUid[i]);
    }
    for (int i = 0; i < list2RecipientUid.length; i++) {
      mergedListRecipientUid.add(list2RecipientUid[i]);
    }

    for (int i = 0; i < list1Text.length; i++) {
      mergedListText.add(list1Text[i]);
    }
    for (int i = 0; i < list2Text.length; i++) {
      mergedListText.add(list2Text[i]);
    }

    for (int i = 0; i < list1Voice.length; i++) {
      mergedListVoice.add(list1Voice[i]);
    }
    for (int i = 0; i < list2Voice.length; i++) {
      mergedListVoice.add(list2Voice[i]);
    }

    for (int i = 0; i < list1File.length; i++) {
      mergedListFile.add(list1File[i]);
    }
    for (int i = 0; i < list2File.length; i++) {
      mergedListFile.add(list2File[i]);
    }

    for (int i = 0; i < list1Image.length; i++) {
      mergedListImage.add(list1Image[i]);
    }
    for (int i = 0; i < list2Image.length; i++) {
      mergedListImage.add(list2Image[i]);
    }

    //looping through the merged list: in  every iterarion rmeoving the newest message and placing it in Read/Unread lists.
    int len = mergedListCreationTime.length;
    for (int j = 0; j < len; j++) {
      int maxCreationTime = 0, indexMaxCreationTime = -1;

      for (int i = 0; i < mergedListCreationTime.length; i++) {
        if (int.parse(mergedListCreationTime[i]) > maxCreationTime) {
          maxCreationTime = int.parse(mergedListCreationTime[i]);
          indexMaxCreationTime = i;
        }
      }

      String senderUid = mergedListSenderUid[indexMaxCreationTime];
      String recipientUid = mergedListRecipientUid[indexMaxCreationTime];
      //find out whether the sender is me or my partner.  I need to know my partner's uid
      String myPartnerUid = "";
      if (this.uid == senderUid)
        myPartnerUid = recipientUid;
      else
        myPartnerUid = senderUid;
      String prefMyLastVisitThisChat = prefs.getString(myPartnerUid) ?? "";
      int myLastVisitThisChat = prefMyLastVisitThisChat.length > 0
          ? int.parse(prefMyLastVisitThisChat)
          : 0;
      //if my visit had been before the  last visit to this chat group
      if (myLastVisitThisChat <
          int.parse(mergedListCreationTime[indexMaxCreationTime])) {
        unreadListSenderUid.add(senderUid);
        unreadListRecipientUid.add(recipientUid);
        unreadListCreationTime
            .add(mergedListCreationTime[indexMaxCreationTime]);
        unreadListImage.add(mergedListImage[indexMaxCreationTime]);
        unreadListText.add(mergedListText[indexMaxCreationTime]);
        unreadListVoice.add(mergedListVoice[indexMaxCreationTime]);
        unreadListFile.add(mergedListFile[indexMaxCreationTime]);
      } else {
        readListSenderUid.add(senderUid);
        readListRecipientUid.add(recipientUid);
        readListCreationTime.add(mergedListCreationTime[indexMaxCreationTime]);
        readListImage.add(mergedListImage[indexMaxCreationTime]);
        readListText.add(mergedListText[indexMaxCreationTime]);
        readListVoice.add(mergedListVoice[indexMaxCreationTime]);
        readListFile.add(mergedListFile[indexMaxCreationTime]);
      }

      // we need to remove the newest message from the merged lists
      mergedListCreationTime.removeAt(indexMaxCreationTime);
      mergedListSenderUid.removeAt(indexMaxCreationTime);
      mergedListRecipientUid.removeAt(indexMaxCreationTime);
      mergedListImage.removeAt(indexMaxCreationTime);
      mergedListText.removeAt(indexMaxCreationTime);
      mergedListVoice.removeAt(indexMaxCreationTime);
      mergedListFile.removeAt(indexMaxCreationTime);
    }

   
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
              "Chats",
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
        currentIndex: 4,
        onTap: (int index) {
          setState(() {
            this.indexBottomBar = index;
          });

          if (this.indexBottomBar == 0) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Profile()));
          }

          if (this.indexBottomBar == 1) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new MenuGroups()));
          } else if (this.indexBottomBar == 3) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Meet(this.uid)));
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
    );
  }
}
