import 'package:flutter/material.dart';
import 'package:areastudent/data/constants.dart';
import 'dart:io';

Widget signupInputBox(
    {String labelText,
    TextEditingController controller,
    TextInputType textInputType}) {
  return new TextFormField(
    decoration: new InputDecoration(
      labelText: labelText,
      fillColor: Colors.grey[100],
      filled: true,
      contentPadding: EdgeInsets.only(top:10.0, left:10.0, bottom: 10.0,),
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
      child: new Text(screen8SendVerificationCodeButton,
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
