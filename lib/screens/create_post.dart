import 'package:flutter/material.dart';
import 'package:areastudent/data/constants.dart';
import 'package:areastudent/tools/auth_service.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:areastudent/tools/firebase_methods.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePost extends StatefulWidget {
  String op = "";
  String existingPostId;
  CreatePost(this.op, this.existingPostId);
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String tag1 = "123456789", tag2 = "123456789", tag3 = "123456789";
  TextEditingController controllerPostText = new TextEditingController();
  String textWarning = "";
  List<String> postsId = [];
  List<File> postImageList = [];
  FirebaseMethods firebaseMethods = new FirebaseMethods();

  onPressedCreateButton() async {
    if (this.controllerPostText.text.toString().length == 0 &&
        postImageList.length == 0) {
      setState(() {
        this.textWarning = screen13Warning;
      });

      return;
    } else {
      displayProgressDialog(context);

      await firebaseMethods.createNewPost(
          widget.op,
          this.controllerPostText.text,
          this.postImageList,
          this.postsId,
          this.tag1,
          this.tag2,
          this.tag3);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String postId = prefs.getString('postId');

     

      if (widget.op == "createCommentPost" && this.postImageList.length > 0) {
         firebaseMethods.updatePostsComments(postId, widget.existingPostId);
        await firebaseMethods.uploadPostImages(this.postImageList, postId);
        List<String> imagesUrl = prefs.getStringList('imagesUrl');        
        await firebaseMethod.updatePostsImages(
            "createCommentPost", imagesUrl, postId, this.postsId);
      } else if (widget.op == "createPost" && this.postImageList.length > 0) {
          await firebaseMethods.uploadPostImages(this.postImageList, postId);
          List<String> imagesUrl = prefs.getStringList('imagesUrl');
          
           if(imagesUrl.length<2) imagesUrl.add('123456789');
          

          await firebaseMethod.updatePostsImages(
              "createPost", imagesUrl, postId, this.postsId);
      }
      

      closeProgressDialog(context);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          //welcome title & welcome body
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () {
                      String textNewTag = "";
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                                title: new Text("Add a tag:"),
                                //content: new Text("Hey! I'm Coflutter!"),
                                content: new TextField(
                                  //controller: controllerAddTag,
                                  onChanged: (text) {
                                    //print("First text field: $text");
                                    textNewTag = text;
                                  },
                                  autofocus: true,
                                  decoration: new InputDecoration(
                                      labelText: '', hintText: 'Tag'),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      setState(() {
                                        if (textNewTag.length > 0)
                                          this.tag1 = textNewTag;
                                      });

                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                    child: tag1 != '123456789'
                        ? Text(tag1,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue))
                        : Text("Add Tag",
                            style:
                                TextStyle(fontSize: 16, color: Colors.blue))),
                GestureDetector(
                    onTap: () {
                      String textNewTag = "";
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                                title: new Text("Add a tag:"),
                                //content: new Text("Hey! I'm Coflutter!"),
                                content: new TextField(
                                  //controller: controllerAddTag,
                                  onChanged: (text) {
                                    //print("First text field: $text");
                                    textNewTag = text;
                                  },
                                  autofocus: true,
                                  decoration: new InputDecoration(
                                      labelText: '', hintText: 'Tag'),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      setState(() {
                                        if (textNewTag.length > 0)
                                          this.tag2 = textNewTag;
                                      });

                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                    child: tag2 != '123456789'
                        ? Text(tag2,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue))
                        : Text("Add Tag",
                            style:
                                TextStyle(fontSize: 16, color: Colors.blue))),
                GestureDetector(
                    onTap: () {
                      String textNewTag = "";
                      showDialog(
                          context: context,
                          builder: (_) => new AlertDialog(
                                title: new Text("Add a tag:"),
                                //content: new Text("Hey! I'm Coflutter!"),
                                content: new TextField(
                                  //controller: controllerAddTag,
                                  onChanged: (text) {
                                    //print("First text field: $text");
                                    textNewTag = text;
                                  },
                                  autofocus: true,
                                  decoration: new InputDecoration(
                                      labelText: '', hintText: 'Tag'),
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      setState(() {
                                        if (textNewTag.length > 0)
                                          this.tag3 = textNewTag;
                                      });

                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              ));
                    },
                    child: tag3 != '123456789'
                        ? Text(tag3,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue))
                        : Text("Add Tag",
                            style:
                                TextStyle(fontSize: 16, color: Colors.blue))),
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: controllerPostText,
                keyboardType: TextInputType.text,
                maxLength: 200,
                maxLines: 10,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0)),
                    hintText: 'Your text'),
              ),
            ),
            SizedBox(height: 2.0),
            Center(
              child: GestureDetector(
                onTap: () async {
                  File file;
                  try {
                    file = await ImagePicker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 200,
                        maxWidth: 200);
                  } on PlatformException catch (e) {
                    print("Image picker issue: " + e.toString());
                  }

                  if (file != null) {
                    List<File> imageFile = new List();
                    imageFile.add(file);

                    if (this.postImageList == null) {
                      this.postImageList =
                          new List.from(imageFile, growable: true);
                    } else {
                      if (this.postImageList.length > 1) {
                        showSnackBar("screen17TooMuchImages", scaffoldKey);
                        return;
                      }

                      for (int s = 0; s < imageFile.length; s++) {
                        this.postImageList.add(file);
                      }
                    }
                    setState(() {});
                  }
                },
                child: new CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent,
                    child: new Icon(Icons.add_a_photo,
                        color: Colors.white, size: 24.0)),
              ),
            ),
            SizedBox(height: 10.0),
            multiImagePickerList(
                imageList: this.postImageList,
                removeNewImage: (index) {
                  setState(() {
                    this.postImageList.removeAt(index);
                  });
                }),
            Text(
              textWarning,
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        if (this.controllerPostText.text.toString().length ==
                                0 &&
                            postImageList.length == 0) {
                          setState(() {
                            this.textWarning = screen13Warning;
                          });

                          return;
                        } else {
                          onPressedCreateButton();
                        }
                      },
                      child: postCreationButton()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
