import 'package:areastudent/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:areastudent/tools/firebase_methods.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' show get;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:location/location.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController controllerFirstName = new TextEditingController();
  TextEditingController controllerLastName = new TextEditingController();
  TextEditingController controllerPhoneNumber = new TextEditingController();
  TextEditingController controllerAboutMe = new TextEditingController();
  List<String> posts = [];
  List<String> blocked = [];
  List<String> followers = [];
  List<String> following = [];
  DateTime _birthDate = DateTime.now();
  String birthDate;
  String userAddress;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseMethods firebaseMethod = new FirebaseMethods();
  String uid = "";
  List<DocumentSnapshot> globalSnapshot;

  int _radioValue = 0;
  String gender = "male";
  List<File> imageList = [];
  String textBirthdate = "Birth Date";
  String textAcademicField = "Academic Field";
  BuildContext context;
  bool tempUid = false;

  List<String> academicFields = [
    'Agriculture',
    'Anthropology',
    'Archeology',
    'Architecture',
    'Arts',
    'Astronomy',
    'Biology',
    'Business',
    'Chemistry',
    'CS',
    'Culinary',
    'Economics',
    'Education',
    'Engineering',
    'Environmental',
    'Geography',
    'History',
    'Journalism',
    'Languages',
    'Librarianship',
    'Literature',
    'Law',
    'Mathematics',
    'Medicine',
    'Military',
    'Philosophy',
    'Physics',
    'Political',
    'Psychology',
    'Religion',
    'Social-Work',
    'Sociology',
    'Space',
    'Statistics',
    'Transportation',
  ];

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      return uid;
    } catch (e) {
      this.tempUid = true;
      return "";
    }
  }

  Future<void> populateSignupFields() async {
    this.uid = await inputData();
    if (this.tempUid == true) {
      this.uid = "M0B7RtHW6zYOwkPhcqoHdigwEEs2";
      this.tempUid = true;
    }
    try {
      final QuerySnapshot result = await Firestore.instance
          .collection('userData')
          .where('uid', isEqualTo: uid)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;

      setState(() {
        controllerFirstName.text = snapshot[0].data['firstName'];
        controllerLastName.text = snapshot[0].data['lastName'];
        controllerPhoneNumber.text = snapshot[0].data['phoneNumber'];
        controllerAboutMe.text = snapshot[0].data['aboutMe'];
        this.textAcademicField = snapshot[0].data['academicField'];
        this.textBirthdate = snapshot[0].data['birthDate'];
        this.birthDate = snapshot[0].data['birthDate'];
        this.gender = snapshot[0].data['gender'];

        List<dynamic> str1 = snapshot[0].data['blockedUsers'];
        List<String> str2 = [];
        for (int i = 0; i < str1.length; i++) {
          str2.add(str1[i].toString());
        }
        this.blocked = str2;

        str1 = snapshot[0].data['posts'];
        str2 = [];
        if (str1 != null) {
          for (int i = 0; i < str1.length; i++) {
            str2.add(str1[i].toString());
          }
          this.posts = str2;
        }

        str1 = snapshot[0].data['followers'];
        str2 = [];
        for (int i = 0; i < str1.length; i++) {
          str2.add(str1[i].toString());
        }
        this.followers = str2;

        str1 = snapshot[0].data['following'];
        str2 = [];
        for (int i = 0; i < str1.length; i++) {
          str2.add(str1[i].toString());
        }
        this.following = str2;

        if (this.gender == 'Man')
          _radioValue = 0;
        else
          _radioValue = 1;

        if (snapshot[0].data['profileImages'] != null) {
          List<File> tempList;
          List<dynamic> listImages = snapshot[0].data['profileImages'];
          for (int i = 0; i < listImages.length; i++) {
            downloadImage(listImages[i].toString(), i);
          }
        }
      });
    } on PlatformException catch (e) {
      print("eeeeeeeeeeeeeeeeeeeeeeeee= " + e.toString());
    }
  }

  downloadImage(String url, int index) async {
    var response = await get(url);
    var documentDirectory = await getApplicationDocumentsDirectory();
    File file =
        new File(join(documentDirectory.path, index.toString() + '.png'));
    file.writeAsBytesSync(response.bodyBytes);

    setState(() {
      this.imageList.add(file);
    });
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1980),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _birthDate) {
      this.birthDate = picked.day.toString() +
          "/" +
          picked.month.toString() +
          "/" +
          picked.year.toString();
      setState(() {
        _birthDate = picked;
        textBirthdate = this.birthDate;
      });
    }
  }

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
    } else if (textBirthdate == "Birth Date") {
      showSnackBar(screen4NoBirthDate, scaffoldKey);
      return;
    } else if (this.textAcademicField == "Academic Field") {
      showSnackBar(screen4NoAcademicField, scaffoldKey);
      return;
    }

    var location = Location();
    bool enabled = await location.serviceEnabled();
    String latitude,
        longitude,
        locality,
        administrativeArea,
        subAdministrativeArea,
        country;
    Placemark placeMark;

    if (enabled == true) {
      Position position = await Geolocator().getCurrentPosition(
          /*desiredAccuracy: LocationAccuracy.high*/);
      List<Placemark> newPlace = await Geolocator()
          .placemarkFromCoordinates(position.latitude, position.longitude);

      //important!!!!! subRegion is most important. If non-existent: region.  If non-existent:country.
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
      placeMark = newPlace[0];
      locality = placeMark.locality;
      administrativeArea = placeMark.administrativeArea;
      subAdministrativeArea = placeMark.subAdministrativeArea;
      country = placeMark.country;
    } 

    displayProgressDialog(context);

    String documentID;
    List<String> imagesUrl;
    bool updateImageList;
    bool doesUserAlreadyExist;
    try {
      doesUserAlreadyExist = await firebaseMethod.checkUserAlreadyExists(
          phoneNumber: controllerPhoneNumber.text);

      List<String> blocked = [];

      await firebaseMethod.createUserAccount(
        firstName: controllerFirstName.text,
        lastName: controllerLastName.text,
        phoneNumber: controllerPhoneNumber.text,
        aboutMe: controllerAboutMe.text,
        birthDate: birthDate,
        academicField: this.textAcademicField,
        latitude: latitude,
        longitude: longitude,
        country: country,
        region: administrativeArea,
        subRegion: subAdministrativeArea,
        locality: locality,
        gender: gender,
        blockedUsers: this.blocked,
        posts: this.posts,
        followers: this.followers,
        following: this.following,
      );
      if (imageList.length > 0) {
        imagesUrl =
            await firebaseMethod.uploadProductImages(imageList: imageList);
        updateImageList =
            await firebaseMethod.updateProductImages(data: imagesUrl);
      }
      closeProgressDialog(context);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('accountExists', true);

      //it's time for authentication through SMS
      //Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context) =>  new Authentication() ));
      Navigator.of(context).pop();
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
    try {
      var documentDirectory = await getApplicationDocumentsDirectory();
      file = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    } on PlatformException catch (e) {
      print("Image picker issue: " + e.toString());
    }
    if (file != null) {
      //imagesMap[imagesMap.length] = file;
      List<File> imageFile = new List();
      imageFile.add(file);
      //imageList = new List.from(imageFile);
      if (imageList == null) {
        imageList = new List.from(imageFile, growable: true);
      } else {
        if (imageList.length >= 3) {
          showSnackBar(screen4NoMore3Images, scaffoldKey);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    populateSignupFields();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
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
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: signupInputBox(
                  labelText: screen4LastName,
                  controller: controllerLastName,
                  textInputType: TextInputType.text),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: signupInputBox(
                  labelText: screen4PhoneNumber,
                  controller: controllerPhoneNumber,
                  textInputType: TextInputType.phone),
            ),
            SizedBox(
              width: 500.0,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: RaisedButton(
                  onPressed: () {
                    selectDate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 6.0,
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          this.textBirthdate,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600]),
                        )),
                  ),
                  textColor: Colors.grey,
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black45),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black45),
                  ),
                ),
                child: SizedBox(
                  width: 500.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: new DropdownButton<String>(
                        underline: SizedBox(),
                        iconSize: 2,
                        hint: new Text(
                          this.textAcademicField,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600]),
                        ),
                        items: academicFields.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            this.textAcademicField = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: controllerAboutMe,
                decoration: new InputDecoration(
                    labelText: 'About',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow))),
              ),
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
