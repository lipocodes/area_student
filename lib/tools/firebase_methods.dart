import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class FirebaseMethods {
  Firestore firestore = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final dbRef = FirebaseDatabase.instance.reference();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  


  removePost(List<String> postsId, String postId) async{
     String uid = await inputData();
    await firestore.collection("posts").document(postId).delete();
    postsId.remove(postId);
    await firestore.collection("userData").document(uid).updateData({'posts': postsId});
     
  }

  login() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await auth.signInWithCredential(credential)).user;

      var uid = user.uid;
    } catch (err) {
      print("eeeeeeeeeeeeeeeeeeeeeeeeeee= " + err);
    }
  }

  logout() {
    _googleSignIn.signOut();
  }

  bool authenticateGoogle() {
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






  Future createNewPost(String postText, List<File> postImageList, List<String> postId, String tag1, String tag2, String tag3, ) async {
    List postsId = postId;
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

      placeMark = newPlace[0];
      locality = placeMark.locality;
      administrativeArea = placeMark.administrativeArea;
      subAdministrativeArea = placeMark.subAdministrativeArea;
      country = placeMark.country;
    }

      String uid = await inputData();
      int now = new DateTime.now().millisecondsSinceEpoch;
      String postName = uid + '_' + now.toString();

      await firestore
          .collection("posts")
          .document(uid + '_' + now.toString())
          .setData(({
            'creationCountry': country,
            'creationRegion': administrativeArea,
            'creationSubRegion': subAdministrativeArea,
            'creationTime': now.toString(),
            'creatorUid': uid,
            'postId': postName,
            'text': postText,
            'tags' : [tag1, tag2, tag3],
          }))
          .whenComplete(() async{

           SharedPreferences prefs = await SharedPreferences.getInstance();
           await prefs.setString('postId', postName);

           //postsId.add(postId);
           
           await firestore
          .collection("userData")
          .document(uid).updateData({'posts': postsId}); 

            
          });
  }



    Future<List<String>> uploadPostImages(List<File> imageList, String postId) async {
    List<String> imagesUrl = new List();
    String uid = await inputData();

    try {
      for (int s = 0; s < imageList.length; s++) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("posts")
            .child(postId)
            .child(postId + ".$s.jpg");
        StorageUploadTask uploadTask = storageReference.putFile(imageList[s]);
        await uploadTask.onComplete;
        print('File Uploaded');
        String downloadUrl = await storageReference.getDownloadURL();
        imagesUrl.add(downloadUrl);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
           await prefs.setStringList('imagesUrl', imagesUrl);

     
      return imagesUrl;
    } on PlatformException catch (e) {
      return imagesUrl;
    }
  }



   
  Future<bool> updatePostsImages(List<String> data, String postId, List<String> postsId) async {
    bool msg;
    String uid = await inputData();

    try {
      await firestore
          .collection("posts")
          .document(postId)
          .updateData({'images': data}).whenComplete(() {
        msg = true;
                      });

        postsId.add(postId);
        await firestore.collection("userData").document(uid).updateData({'posts': postsId});              
      
      return msg;
    } on PlatformException catch (e) {
      return false;
    }
  }




  Future<void> createUserAccount({
    String firstName,
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
    List<String> posts,
    List<String> blockedUsers,
    List<String> followers,
    List<String> following,
  }) async {
    String uid = await inputData();

    await firestore
        .collection("userData")
        .document(uid)
        .setData(({
          'uid': uid,
          'firstName': firstName,
          'lastName': lastName,
          'aboutMe': aboutMe,
          'phoneNumber': phoneNumber,
          'birthDate': birthDate,
          'academicField': academicField,
          'latitude': latitude,
          'longitude': longitude,
          'country': country,
          'region': region,
          'subRegion': subRegion,
          'locality': locality,
          'gender': gender,
          'blockedUsers': blockedUsers,
          'posts': posts,
          'followers': followers,
          'following': following,
        }))
        .whenComplete(() {
      updatePreference();
    });
  }

  updatePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('existAccount', true);
  }

  Future<bool> existAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool yes_no = prefs.getBool('existAccount');
    return yes_no;
  }






  Future<List<String>> uploadProductImages({List<File> imageList}) async {
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

  Future<bool> updateProductImages({List<String> data}) async {
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
