
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FirebaseMethods {
  Firestore firestore = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final  dbRef = FirebaseDatabase.instance.reference();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  
  login() async{  
    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
       final GoogleSignInAuthentication googleAuth = await googleUser.authentication; 

       final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await auth.signInWithCredential(credential)).user;

      var uid = user.uid;

          
        
        
    } catch (err){
      print("eeeeeeeeeeeeeeeeeeeeeeeeeee= " + err);
    }
  }

  logout(){
    _googleSignIn.signOut();
  }


    bool authenticateGoogle(){
 

      return true;
  }


Future<bool> checkUserAlreadyExists({String phoneNumber}) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      return false;
    } else {
      return true;
    }
  }

    Future<String> inputData() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  Future<void> createUserAccount(
      {String firstName,
      String lastName,
      String phoneNumber,
      String aboutMe,
      String birthDate,
      String academicField,
      String latitude,
      String longitude,
      String country,
      String region,
      String subRegion,
      String locality,
      String gender,
      List<String> blockedUsers,
      List<String> followers,
      List<String> following,
      }) async {

      String uid = await inputData();
    
      await firestore.collection("userData").document(uid).setData(({
      'uid'  :uid, 
      'firstName': firstName,
      'lastName': lastName,
      'aboutMe' : aboutMe,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'academicField': academicField,
      'latitude' : latitude,
      'longitude' : longitude,
      'country': country,
      'region': region,
      'subRegion': subRegion,
      'locality': locality,
      'gender': gender,
      'blockedUsers': blockedUsers,
      'followers': followers,
      'following': following,
    })).whenComplete( () {
       updatePreference();
    });
    
  }


  updatePreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('existAccount', true);
  }

  Future<bool> existAccount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool yes_no = prefs.getBool('existAccount');
    return yes_no;
  }

  Future<List<String>> uploadProductImages(
      { List<File> imageList}) async {
    List<String> imagesUrl = new List();
      String uid = await inputData();

    try {
      for (int s = 0; s < imageList.length; s++) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("userData")
            .child(uid)
            .child(uid + ".$s.jpg");
        StorageUploadTask uploadTask = storageReference.putFile(imageList[s]);
        await uploadTask.onComplete;
        print('File Uploaded');
        String downloadUrl = await storageReference.getDownloadURL();
        imagesUrl.add(downloadUrl);
      }

      return imagesUrl;
    } on PlatformException catch (e) {
      return imagesUrl;
    }
  }

  Future<bool> updateProductImages({ List<String> data}) async {
    bool msg;
   String uid = await inputData();
   
    try {
      await firestore
          .collection("userData")
          .document(uid)
          .updateData({'profileImages': data}).whenComplete(() {
        msg = true;
      });

      return msg;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
