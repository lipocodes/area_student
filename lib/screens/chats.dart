import 'package:flutter/material.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/cupertino.dart';
import 'menu_groups.dart';
import 'meet.dart';
import 'profile.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int indexBottomBar = 0;
  String uid = "";
  String partnerUid = "";
  String partnerImage = "";
  String partnerName = "";
  List<String> list1MessageId = [];
  List<String> list1SenderUid = [];
  List<String> list1RecipientUid = [];
  List<String> list1CreationTime = [];
  List<String> list1Text = [];
  List<String> list1Voice = [];
  List<String> list1File = [];
  List<String> list1Image = [];

  List<String> list2MessageId = [];
  List<String> list2SenderUid = [];
  List<String> list2RecipientUid = [];
  List<String> list2CreationTime = [];
  List<String> list2Text = [];
  List<String> list2Voice = [];
  List<String> list2File = [];
  List<String> list2Image = [];

  List<String> mergedListMessageId = [];
  List<String> mergedListSenderUid = [];
  List<String> mergedListRecipientUid = [];
  List<String> mergedListCreationTime = [];
  List<String> mergedListText = [];
  List<String> mergedListVoice = [];
  List<String> mergedListFile = [];
  List<String> mergedListImage = [];

  List<String> readListMessageId = [];
  List<String> readListPartnerUid = [];
  List<String> readListPartnerName = [];
  List<String> readListPartnerImage = [];
  List<String> readListSenderUid = [];
  List<String> readListRecipientUid = [];
  List<String> readListCreationTime = [];
  List<String> readListText = [];
  List<String> readListVoice = [];
  List<String> readListFile = [];
  List<String> readListImage = [];

  List<String> unreadListMessageId = [];
  List<String> unreadListPartnerUid = [];
  List<String> unreadListPartnerName = [];
  List<String> unreadListPartnerImage = [];
  List<String> unreadListSenderUid = [];
  List<String> unreadListRecipientUid = [];
  List<String> unreadListCreationTime = [];
  List<String> unreadListText = [];
  List<String> unreadListVoice = [];
  List<String> unreadListFile = [];
  List<String> unreadListImage = [];

  List<String> listViewContentsPartnerUid = [];
  List<String> listViewContentsPartnerName = [];
  List<String> listViewContentsPartnerImage = [];
  List<String> listViewContentsCreationTime = [];
  List<String> listViewContentsText = [];
  List<String> listViewContentsVoice = [];
  List<String> listViewContentsFile = [];
  List<String> listViewContentsImage = [];
  int myLastVisitThisChat;

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      return uid;
    } catch (e) {
      return "";
    }
  }

  Future<String> getMyUid() async {
    this.uid = await inputData();
    await createChatList();
    return this.uid;
  }

  getPartnerDetails(String partnerUidd) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: partnerUidd)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    var temp = snapshot[0].data['profileImages'];
    partnerImage = temp[0].toString();
    partnerName =
        snapshot[0].data['firstName'] + " " + snapshot[0].data['lastName'];
    partnerUid = snapshot[0].data['uid'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyUid(); //which will call  createChatList()
  }

  initiaizeLists() {
    list1MessageId = [];
    list1SenderUid = [];
    list1RecipientUid = [];
    list1CreationTime = [];
    list1Text = [];
    list1Voice = [];
    list1File = [];
    list1Image = [];

    list2MessageId = [];
    list2SenderUid = [];
    list2RecipientUid = [];
    list2CreationTime = [];
    list2Text = [];
    list2Voice = [];
    list2File = [];
    list2Image = [];

    mergedListMessageId = [];
    mergedListMessageId = [];
    mergedListSenderUid = [];
    mergedListRecipientUid = [];
    mergedListCreationTime = [];
    mergedListText = [];
    mergedListVoice = [];
    mergedListFile = [];
    mergedListImage = [];

    readListMessageId = [];
    readListPartnerUid = [];
    readListPartnerName = [];
    readListPartnerImage = [];
    readListSenderUid = [];
    readListRecipientUid = [];
    readListCreationTime = [];
    readListText = [];
    readListVoice = [];
    readListFile = [];
    readListImage = [];

    unreadListMessageId = [];
    unreadListPartnerUid = [];
    unreadListPartnerName = [];
    unreadListPartnerImage = [];
    unreadListSenderUid = [];
    unreadListRecipientUid = [];
    unreadListCreationTime = [];
    unreadListText = [];
    unreadListVoice = [];
    unreadListFile = [];
    unreadListImage = [];

    listViewContentsPartnerUid = [];
    listViewContentsPartnerName = [];
    listViewContentsPartnerImage = [];
    listViewContentsCreationTime = [];
    listViewContentsText = [];
    listViewContentsVoice = [];
    listViewContentsFile = [];
    listViewContentsImage = [];
  }

  //retrieve all the data needed for showing the different chats, arranged by read/unread & time of last message
  createChatList() async {
    displayProgressDialog(context);

    initiaizeLists();



    SharedPreferences prefs = await SharedPreferences.getInstance();

    final QuerySnapshot result1 = await Firestore.instance
        .collection('messages')
        .where('senderUid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot1 = result1.documents;

        

    for (int i = 0; i < snapshot1.length; i++) {
      list1MessageId.add(snapshot1[i].data['id']);
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
        .where('recipientUid', isEqualTo: this.uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot2 = result2.documents;

    for (int i = 0; i < snapshot2.length; i++) {
      list2MessageId.add(snapshot2[i].data['id']);
      list2CreationTime.add(snapshot2[i].data['creationTime']);
      list2SenderUid.add(snapshot2[i].data['senderUid']);
      list2RecipientUid.add(snapshot2[i].data['recipientUid']);
      list2Text.add(snapshot2[i].data['text']);
      list2Voice.add(snapshot2[i].data['attachedVoiceRecording']);
      list2File.add(snapshot2[i].data['attachedFile']);
      list2Image.add(snapshot2[i].data['attachedAttachedImage']);
    }



    //merge the 2 lists into a single list
    for (int i = 0; i < list1MessageId.length; i++) {
      mergedListMessageId.add(list1MessageId[i]);
    }
    for (int i = 0; i < list2MessageId.length; i++) {
      mergedListMessageId.add(list2MessageId[i]);
    }
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


    //looping through the merged list: in  every iterarion removing the newest message and placing it in Read/Unread lists.
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

      await getPartnerDetails(myPartnerUid);
       
      //once we know who is our partner, we need his image
      int prefMyLastVisitThisChat = prefs.getInt(myPartnerUid) ?? 0;
      this.myLastVisitThisChat = prefMyLastVisitThisChat;
               
      //if my visit had been before the  last visit to this chat group
      if (!unreadListPartnerUid.contains(partnerUid) &&   this.myLastVisitThisChat <
          int.parse(mergedListCreationTime[indexMaxCreationTime])) {
        unreadListPartnerUid.add(partnerUid);
        unreadListPartnerName.add(partnerName);
        unreadListPartnerImage.add(partnerImage);
        unreadListSenderUid.add(senderUid);
        unreadListRecipientUid.add(recipientUid);
        unreadListCreationTime
            .add(mergedListCreationTime[indexMaxCreationTime]);
        unreadListImage.add(mergedListImage[indexMaxCreationTime]);
        unreadListText.add(mergedListText[indexMaxCreationTime]);
        unreadListVoice.add(mergedListVoice[indexMaxCreationTime]);
        unreadListFile.add(mergedListFile[indexMaxCreationTime]);
      } else if(!readListPartnerUid.contains(partnerUid) &&  !unreadListPartnerUid.contains(partnerUid)) {
        readListPartnerUid.add(partnerUid);
        readListPartnerName.add(partnerName);
        readListPartnerImage.add(partnerImage);
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
  
    //At last: unify the read & unread lists so we have a list to build the ListView
    for (int k = 0; k < unreadListPartnerUid.length; k++) {
      listViewContentsPartnerUid.add(unreadListPartnerUid[k]);
    }
    for (int k = 0; k < readListPartnerUid.length; k++) {
      listViewContentsPartnerUid.add(readListPartnerUid[k]);
    }
    for (int k = 0; k < unreadListPartnerName.length; k++) {
      listViewContentsPartnerName.add(unreadListPartnerName[k]);
    }
    for (int k = 0; k < readListPartnerName.length; k++) {
      listViewContentsPartnerName.add(readListPartnerName[k]);
    }

    for (int k = 0; k < unreadListPartnerImage.length; k++) {
      listViewContentsPartnerImage.add(unreadListPartnerImage[k]);
    }
    for (int k = 0; k < readListPartnerImage.length; k++) {
      listViewContentsPartnerImage.add(readListPartnerImage[k]);
    }

    for (int k = 0; k < unreadListCreationTime.length; k++) {
      listViewContentsCreationTime.add(unreadListCreationTime[k]);
    }
    for (int k = 0; k < readListCreationTime.length; k++) {
      listViewContentsCreationTime.add(readListCreationTime[k]);
    }
    for (int k = 0; k < unreadListText.length; k++) {
      listViewContentsText.add(unreadListText[k]);
    }
    for (int k = 0; k < readListText.length; k++) {
      listViewContentsText.add(readListText[k]);
    }
    for (int k = 0; k < unreadListImage.length; k++) {
      listViewContentsImage.add(unreadListImage[k]);
    }
    for (int k = 0; k < readListImage.length; k++) {
      listViewContentsImage.add(readListImage[k]);
    }
    for (int k = 0; k < unreadListVoice.length; k++) {
      listViewContentsVoice.add(unreadListVoice[k]);
    }
    for (int k = 0; k < readListVoice.length; k++) {
      listViewContentsVoice.add(readListVoice[k]);
    }
    for (int k = 0; k < unreadListFile.length; k++) {
      listViewContentsFile.add(unreadListFile[k]);
    }
    for (int k = 0; k < readListFile.length; k++) {
      listViewContentsFile.add(readListFile[k]);
    }

    closeProgressDialog(context);

    setState(() {});
  }


  removeChatRoom(String partnerUid) async {
      
    for(int a=0; a<list1CreationTime.length; a++){ 
      if(list1RecipientUid[a]==partnerUid){
         await Firestore.instance.collection('messages').document(list1MessageId[a]).delete();
      }
    }
     for(int a=0; a<list2CreationTime.length; a++){ 
      if(list2SenderUid[a]==partnerUid){
           await Firestore.instance.collection('messages').document(list2MessageId[a]).delete();
      }
    }
    
    createChatList();
  }


  
  @override
  Widget build(BuildContext context) {

   
    bool needReturn = false;

    if (listViewContentsPartnerUid == null ||
        listViewContentsPartnerUid.length == 0)
      needReturn = true;
    else if (listViewContentsPartnerImage == null ||
        listViewContentsPartnerImage.length == 0)
      needReturn = true;
    else if (listViewContentsPartnerName == null ||
        listViewContentsPartnerName.length == 0) needReturn = true;
    if (needReturn == true) {
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
          currentIndex: 3,
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
            } else if (this.indexBottomBar == 2) {
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
                icon: Icon(Icons.favorite_border, size: 30.0),
                title: Text('Meet')),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline, size: 30.0),
                title: Text('Chats'))
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Center(
              child: Text("No messages yet!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue))),
        ),
      );
    }

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
        currentIndex: 3,
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
          } else if (this.indexBottomBar == 2) {
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
              icon: Icon(Icons.favorite_border, size: 30.0),
              title: Text('Meet')),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 30.0),
              title: Text('Chats'))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 50.0),
          this.listViewContentsPartnerUid.length > 0
              ? SizedBox(
                  height: 400,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 3, color: Colors.white24),
                        scrollDirection: Axis.vertical,
                        itemCount: listViewContentsPartnerUid.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, right: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (this.myLastVisitThisChat >=
                                        int.parse(listViewContentsCreationTime[
                                            index])) ...[
                                      GestureDetector(
                                        onTap: () {removeChatRoom(listViewContentsPartnerUid[
                                                        index].toString());},
                                        child: Text("X",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300)),
                                      ),
                                    ]
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                        new CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                new ChatScreen(
                                                    listViewContentsPartnerUid[
                                                        index],
                                                    listViewContentsPartnerName[
                                                        index],
                                                    " ",
                                                    " ",
                                                    listViewContentsPartnerImage[
                                                        index])));

                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    int temp = await prefs.getInt(
                                        listViewContentsPartnerUid[index]);

                                    getMyUid();
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                listViewContentsPartnerImage[
                                                    index]),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              //SizedBox(width: 10),
                                              Text(
                                                listViewContentsPartnerName[
                                                    index],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        this.myLastVisitThisChat <
                                                                int.parse(
                                                                    listViewContentsCreationTime[
                                                                        index])
                                                            ? FontWeight.w900
                                                            : FontWeight.w300),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                timestampToTimeGap(
                                                    listViewContentsCreationTime[
                                                        index]),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        this.myLastVisitThisChat <
                                                                int.parse(
                                                                    listViewContentsCreationTime[
                                                                        index])
                                                            ? FontWeight.w900
                                                            : FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              if (listViewContentsText[index]
                                                          .length >
                                                      0 &&
                                                  listViewContentsText[index] !=
                                                      null)
                                                Text(
                                                  listViewContentsText[index],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: this
                                                                  .myLastVisitThisChat <
                                                              int.parse(
                                                                  listViewContentsCreationTime[
                                                                      index])
                                                          ? FontWeight.w900
                                                          : FontWeight.w300),
                                                ),
                                              if (listViewContentsImage[index]
                                                          .length >
                                                      0 &&
                                                  listViewContentsImage[
                                                          index] !=
                                                      null)
                                                Text(
                                                  "Image",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: this
                                                                  .myLastVisitThisChat <
                                                              int.parse(
                                                                  listViewContentsCreationTime[
                                                                      index])
                                                          ? FontWeight.w900
                                                          : FontWeight.w300),
                                                ),
                                              if (listViewContentsVoice[index]
                                                          .length >
                                                      0 &&
                                                  listViewContentsVoice[
                                                          index] !=
                                                      null)
                                                Text(
                                                  "Voice",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: this
                                                                  .myLastVisitThisChat <
                                                              int.parse(
                                                                  listViewContentsCreationTime[
                                                                      index])
                                                          ? FontWeight.w900
                                                          : FontWeight.w300),
                                                ),
                                              if (listViewContentsFile[index]
                                                          .length >
                                                      0 &&
                                                  listViewContentsFile[index] !=
                                                      null)
                                                Text(
                                                  "Attachment",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: this
                                                                  .myLastVisitThisChat <
                                                              int.parse(
                                                                  listViewContentsCreationTime[
                                                                      index])
                                                          ? FontWeight.w900
                                                          : FontWeight.w300),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
        ]),
      ),
    );
  }
}
