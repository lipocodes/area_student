import 'dart:async';
import 'dart:math';

import 'package:areastudent/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:areastudent/data/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:areastudent/tools/local_audio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:areastudent/screens/images_in_large.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;
bool myOperation = false;
bool isRecordingNow = false;
String tempRecording = "";
File tempAttachedImage;
String tempAttachment = "";
FocusNode focusTextField = new FocusNode();
bool isTextFieldFocus = false;

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
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final List<Notification> notifications = [];
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText;
  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
  File attachedImage;
  StorageReference storageReference;
  StorageUploadTask uploadTask;

  double recorderWidth = 40.0;
  double recorderHeight = 40.0;
  double recorderBorderRadius = 15.0;
  var recorder;
  String documentId;

  bool keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  void attachFile() async {
    String filePath = await FilePicker.getFilePath(type: FileType.any);
    tempAttachment = filePath;
    documentId = this._randomString(6);

    _firestore.collection('messages').document(documentId).setData({
      'id'  : documentId,
      'creationTime': new DateTime.now().millisecondsSinceEpoch.toString(),
      'recipientUid': widget.creatorUid,
      'senderName': loggedInUser.displayName,
      'senderUid': loggedInUser.uid,
      'text': "",
      'attachedAttachedImage': "",
      'attachedVoiceRecording': "",
      'attachedFile': tempAttachment,
    });

    storageReference = FirebaseStorage.instance
        .ref()
        .child("attachments")
        .child(loggedInUser.uid)
        .child(new DateTime.now().toString());
    uploadTask = storageReference.putFile(File(tempAttachment));
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      _firestore.collection('messages').document(documentId).updateData({
        'attachedFile': fileURL,
      });
    }).then((res) {});
  }

  Widget buttonRecordVoice() {
    return GestureDetector(
      onTapDown: ((res) {
        print("held!");
        setState(() {
          this.recorderWidth *= 2;
          this.recorderHeight *= 2;
          this.recorderBorderRadius *= 2;
        });
        startVoiceRecording();
      }),
      onTapCancel: (() {
        print("Released!");
        setState(() {
          this.recorderWidth /= 2;
          this.recorderHeight /= 2;
          this.recorderBorderRadius /= 2;
        });

        AudioCache player = new AudioCache();
        const alarmAudioPath = "audio/beep.wav";
        player.play(alarmAudioPath);

        stopVoiceRecording();
      }),
      child: Container(
        width: recorderWidth,
        height: recorderHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(recorderBorderRadius)),
          gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(253, 173, 38, 1),
              Color.fromRGBO(253, 111, 74, 1),
              Color.fromRGBO(253, 40, 118, 1),
            ],
          ),
        ),
        child: IconButton(
          icon: Icon(Icons.keyboard_voice),
          iconSize: 25,
          color: Colors.black,
          onPressed: (() {}),
        ),
      ),
    );
  }

  void startRecording(directoryPath) async {
    int now = DateTime.now().millisecondsSinceEpoch;
    File f = File(directoryPath + "/" + now.toString() + ".wav");
    /*await AudioRecorder.start(
        path: f.path, audioOutputFormat: AudioOutputFormat.WAV);*/

    this.recorder = FlutterAudioRecorder(f.path,
        audioFormat: AudioFormat.AAC); // or AudioFormat.WAV
    try{
    await recorder.initialized;

    await this.recorder.start();
    var recording = await recorder.current(channel: 0);
    } catch(e) {print("wwwwwwwwwwwwwwwwwwwwwwwwwwwww= " + e.toString());}
  }

  void startVoiceRecording() async {
    try {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      new Directory(appDocDirectory.path + '/' + 'voiceRecording')
          .create(recursive: true)
          .then((Directory directory) {
        startRecording(directory.path);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void stopVoiceRecording() async {
   var result;
    try{
    result = await recorder.stop();
    }
     catch(e) {}
    //print("vvvvvvvvvvvvvvvvvvvvvvvvvvvv= " + result.toString());
    String documentId = this._randomString(6);
    tempRecording = result.path;

    _firestore.collection('messages').document(documentId).setData({
      'id'  : documentId,
      'creationTime': new DateTime.now().millisecondsSinceEpoch.toString(),
      'recipientUid': widget.creatorUid,
      'senderName': loggedInUser.displayName,
      'senderUid': loggedInUser.uid,
      'text': "",
      'attachedAttachedImage': "",
      'attachedVoiceRecording': "",
      'attachedFile': "",
    });

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("audio")
        .child(loggedInUser.uid)
        .child(new DateTime.now().toString());
    StorageUploadTask uploadTask =
        storageReference.putFile(File(tempRecording));
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      _firestore
          .collection('messages')
          .document(documentId)
          .updateData({'attachedVoiceRecording': fileURL});
    });
  }

  Future startUploadImage() async {
    if (this.attachedImage == null) return;
    String documentId = this._randomString(6);

    _firestore.collection('messages').document(documentId).setData({
      'id'  : documentId,
      'creationTime': new DateTime.now().millisecondsSinceEpoch.toString(),
      'recipientUid': widget.creatorUid,
      'senderName': loggedInUser.displayName,
      'senderUid': loggedInUser.uid,
      'text': "",
      'attachedAttachedImage': "",
      'attachedVoiceRecording': "",
      'attachedFile': "",
    });

    storageReference = FirebaseStorage.instance
        .ref()
        .child("images")
        .child(loggedInUser.uid)
        .child(new DateTime.now().toString());
    uploadTask = storageReference.putFile(this.attachedImage);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      _firestore
          .collection('messages')
          .document(documentId)
          .updateData({'attachedAttachedImage': fileURL});
    }).then((res) {
      myOperation = true;
    });
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      int rc = rand.nextInt(33) + 89;
      return rc;
    });

    return new String.fromCharCodes(codeUnits);
  }

  void attachImage() async {
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      this.attachedImage = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
      tempAttachedImage = this.attachedImage;
      //showSnackBar("Sending image..", scaffoldKey);
      //this.startUploadImage();
    } on PlatformException catch (e) {
      print("Image picker issue: " + e.toString());
    }
  }

  void checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  void onFocusChange() {
    //debugPrint("Focus: " + focusTextField.hasFocus.toString());
    try {
      setState(() {
        if (focusTextField.hasFocus.toString() == "true")
          isTextFieldFocus = true;
        else
          isTextFieldFocus = false;
      });
    } catch (e) {}
  }

  updateTimeVisitInSharedPrefs() async {
    int timeNow = new DateTime.now().millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(widget.creatorUid, timeNow);
 
  }

  

  @override
  void initState() {
    super.initState();

    getCurrentUser();

    checkPermissions();

    updateTimeVisitInSharedPrefs();


    messageTextController.addListener(onFocusChange);

    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaa= " + message.toString());
      return;
    }, onResume: (Map<String, dynamic> message) {
      print("bbbbbbbbbbbbbbbbbbbbbbbbbbbbb= " + message.toString());
      
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print("cccccccccccccccccccccccccccccc= " + message.toString());

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
      resizeToAvoidBottomInset: true,
      key: scaffoldKey,
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
                child: widget.iconGroup.length > 10
                    ? ListTile(
                        leading: Image.network(widget.iconGroup),
                      )
                    : Container(),
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
                  buttonRecordVoice(),
                  SizedBox(width: 20.0),
                  SizedBox(
                    width: 180.0,
                    child: TextField(
                      minLines: 1,
                      maxLines: 5,
                      controller: messageTextController,
                      focusNode: focusTextField,
                      onChanged: (value) {
                        messageText = value;
                        //keyboardIsVisible();
                      },
                      decoration:
                          new InputDecoration.collapsed(hintText: 'Type ...'),
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.image,
                      ),
                      iconSize: 20,
                      onPressed: () {
                        attachImage();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.attachment,
                      ),
                      iconSize: 20,
                      onPressed: () {
                        attachFile();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                      ),
                      iconSize: 40,
                      color: Colors.black,
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        String documentId = this._randomString(6);
                        if (messageTextController.text.length == 0) return;
                        _firestore.collection('messages').document(documentId).setData({
                          'id'  : documentId,
                          'creationTime': new DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          'recipientUid': widget.creatorUid,
                          'senderName': loggedInUser.displayName,
                          'senderUid': loggedInUser.uid,
                          'text': messageTextController.text,
                          'attachedAttachedImage': "",
                          'attachedVoiceRecording': "",
                          'attachedFile': "",
                        });
                        messageTextController.clear();
                      },
                    ),
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
  ScrollController controllerListView = ScrollController();
  String creatorUid;
  String profileImagePostCreator;
  MessagesStream(this.creatorUid, this.profileImagePostCreator);
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 1000),
        () => controllerListView
            .jumpTo(controllerListView.position.maxScrollExtent));
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('creationTime', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        Timer(
            Duration(milliseconds: 1000),
            () => controllerListView
                .jumpTo(controllerListView.position.maxScrollExtent));
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageAttachedImage = message.data['attachedAttachedImage'];
          if (messageAttachedImage.toString().contains('https'))
            tempAttachedImage = null;
          final messageAttachedVoiceRecording =
              message.data['attachedVoiceRecording'];
          if (messageAttachedVoiceRecording.toString().contains('https'))
            tempRecording = "";
          final messageAttachedFile = message.data['attachedFile'];
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
              attachedImage: messageAttachedImage,
              attachedVoiceRecording: messageAttachedVoiceRecording,
              attachedFile: messageAttachedFile,
              isMe: currentUser == senderUid,
              profileImagePostCreator: profileImagePostCreator,
              creationTime: creationTime,
            );

            messageBubbles.add(messageBubble);
          }
        }

        return Expanded(
          child: ListView(
            controller: controllerListView,
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
      this.attachedImage,
      this.attachedVoiceRecording,
      this.attachedFile,
      this.isMe,
      this.profileImagePostCreator,
      this.creationTime});

  final String sender;
  final String text;
  final String attachedImage;
  final String attachedVoiceRecording;
  final String attachedFile;
  final bool isMe;
  final String profileImagePostCreator;
  final String creationTime;
  final controllerTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    isTextFieldFocus = false;
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
          if (text.length > 0) ...[
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
          ] else if (tempAttachedImage != null) ...[
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(tempAttachedImage.path),
            )
          ] else if (attachedImage.length > 0) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new ImageInLarge(attachedImage)));
              },
              child: SizedBox(
                width: 200,
                height: 200,
                child: CachedNetworkImage(
                  imageUrl: attachedImage,
                  placeholder: (context, url) => Container(
                    child: Center(child: new CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  fadeInCurve: Curves.easeIn,
                  fadeInDuration: Duration(milliseconds: 1000),
                  fit: BoxFit.fill,
                ),
              ),
            )
          ] else if (tempRecording.length > 0) ...[
            SizedBox(width: 280, height: 50, child: LocalAudio(tempRecording)),
          ] else if (attachedVoiceRecording.length > 0) ...[
            SizedBox(
                width: 280,
                height: 50,
                child: LocalAudio(attachedVoiceRecording)),
          ] else if (tempAttachment.length > 0) ...[
            Material(
              elevation: 5.0,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          OpenFile.open(tempAttachment);
                        },
                        child: Text(
                          "Attached File",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                      ),
                    ]),
              ),
            ),
          ] else if (attachedFile.length > 0) ...[
            Material(
              elevation: 5.0,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch(attachedFile) == true) {
                            await launch(attachedFile);
                          } else {
                            throw 'Could not launch $tempAttachment';
                          }
                        },
                        child: Text(
                          "Attached File",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
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
