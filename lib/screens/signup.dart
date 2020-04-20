import 'package:areastudent/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:areastudent/tools/firebase_methods.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController controllerFirstName = new TextEditingController();
  TextEditingController controllerLastName = new TextEditingController();
  TextEditingController controllerPhoneNumber = new TextEditingController();
  TextEditingController controllerBirthDate = new TextEditingController();
  TextEditingController controllerAcademicField = new TextEditingController();
  TextEditingController controllerCountryCity = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseMethods firebaseMethod = new FirebaseMethods();

  int _radioValue = 0;
  String gender = "male";
  List<File> imageList = [];

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          gender = "Man";
          print("Man");
          break;
        case 1:
          gender = "Woman";
          print("Woman");
          break;
      }
    });
  }

  buttonPrivacyPolicyTapped(context) {
    showPrivacyPolicyDialog(context);
  }

  onPressedSignupButton() async {
    if (controllerFirstName.text.length == 0) {
      showSnackBar(screen4NoFirstName, scaffoldKey);
      return;
    } else if (controllerLastName.text.length == 0) {
      showSnackBar(screen4NoLastName, scaffoldKey);
      return;
    } else if (controllerPhoneNumber.text.length == 0) {
      showSnackBar(screen4NoPhoneNumber, scaffoldKey);
      return;
    } else if (controllerBirthDate.text.length == 0) {
      showSnackBar(screen4NoBirthDate, scaffoldKey);
      return;
    } else if (controllerAcademicField.text.length == 0) {
      showSnackBar(screen4NoAcademicField, scaffoldKey);
      return;
    } else if (controllerCountryCity.text.length == 0) {
      showSnackBar(screen4NoCOuntryCity, scaffoldKey);
      return;
    }

    displayProgressDialog(context);

    String documentID;
    List<String> imagesUrl;
    bool updateImageList;
    bool doesUserAlreadyExist;
    try {
      doesUserAlreadyExist = await firebaseMethod.checkUserAlreadyExists(
          phoneNumber: controllerPhoneNumber.text);
      if (doesUserAlreadyExist == true) {
        closeProgressDialog(context);
        showSnackBar(screen4FirebaseUserAlreadyExists, scaffoldKey);
      } else {
        documentID = await firebaseMethod.createUserAccount(
            firstName: controllerFirstName.text,
            lastName: controllerLastName.text,
            phoneNumber: controllerPhoneNumber.text,
            birthDate: controllerBirthDate.text,
            academicField: controllerAcademicField.text,
            countryCity: controllerCountryCity.text,
            gender: gender);
        if (imageList.length > 0) {
          imagesUrl = await firebaseMethod.uploadProductImages(
              docID: documentID, imageList: imageList);
          updateImageList = await firebaseMethod.updateProductImages(
              docID: documentID, data: imagesUrl);
        }
        closeProgressDialog(context);
        Navigator.of(context).pop();
      }
    } on PlatformException catch (e) {
      closeProgressDialog(context);
      Navigator.of(context).pop();
    }
  }

  onTapProfileImage() {
    pickImage();
  }

  removeImage(int index) async {
    setState(() {
      imageList.removeAt(index);
    });
  }

  pickImage() async {
    File file;
    try{
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch(e) {print("Image picker issue: " + e.toString());}
    if (file != null) {
      //imagesMap[imagesMap.length] = file;
      List<File> imageFile = new List();
      imageFile.add(file);
      //imageList = new List.from(imageFile);
      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
      } else {
        if (imageList.length >= 3) {
          showSnackBar("No more than 3 images please!", scaffoldKey);
          return;
        }

        for (int s = 0; s < imageFile.length; s++) {
          imageList.add(file);
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: new Text(
          "",
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          //welcome title & welcome body
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: new Text(
                screen4Welcome,
                style:
                    new TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900),
              ),
            ),
            new SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 70.0,
              ),
              child: new Text(screen4LetsSetup,
                  style: new TextStyle(fontSize: 22.0, color: Colors.grey)),
            ),
            new SizedBox(height: 30.0),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  new Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  new AssetImage("assets/images/avatar.png")))),
                  GestureDetector(
                    onTap: onTapProfileImage,
                    child: new CircleAvatar(
                        backgroundColor: Colors.lightBlueAccent,
                        child: new Icon(Icons.add_a_photo,
                            color: Colors.white, size: 20.0)),
                  ),
                ],
              ),
            ),
            multiImagePickerList(
                imageList: imageList,
                removeNewImage: (index) {
                  removeImage(index);
                }),
            new SizedBox(
              height: 10.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: signupInputBox(
                  labelText: screen4FirstName,
                  controller: controllerFirstName,
                  textInputType: TextInputType.text),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: signupInputBox(
                  labelText: screen4LastName,
                  controller: controllerLastName,
                  textInputType: TextInputType.text),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: signupInputBox(
                  labelText: screen4PhoneNumber,
                  controller: controllerPhoneNumber,
                  textInputType: TextInputType.phone),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: signupInputBox(
                  labelText: screen4BirthDate,
                  controller: controllerBirthDate,
                  textInputType: TextInputType.datetime),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: signupInputBox(
                  labelText: screen4AcademicField,
                  controller: controllerAcademicField,
                  textInputType: TextInputType.text),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: signupInputBox(
                  labelText: screen4CountryCity,
                  controller: controllerCountryCity,
                  textInputType: TextInputType.text),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(screen4Man),
                new SizedBox(width: 50.0),
                new Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(screen4Woman),
              ],
            ),
            new SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: onPressedSignupButton,
                    child: signupButton(whichScreen: 4)),
              ],
            ),
            new SizedBox(height: 20.0),
            new Center(
              child: new Text(screen4PrivacyPolicy1),
            ),
            new Center(
                child: GestureDetector(
                    onTap: () {
                      buttonPrivacyPolicyTapped(context);
                    },
                    child: new Text(
                      screen4PrivacyPolicy2,
                      style: new TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16.0,
                        color: Colors.lightBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ))),
            new SizedBox(
              height: 40.0,
            )
          ],
        ),
      ),
    );
  }
}
