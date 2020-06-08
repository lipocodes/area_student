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

  removePost(List<String> postsId, String postId) async {
    String uid = await inputData();
    await firestore.collection("posts").document(postId).delete();
    postsId.remove(postId);
    await firestore
        .collection("userData")
        .document(uid)
        .updateData({'posts': postsId});
}


removeCommentPost (op, commentId, List<String> commentsId,  String postId) async {

    String uid = await inputData();
    String collection = "";

    if(op=="createCommentsPostsGroups") collection = "commentsPostsGroups";
    else collection = "commentsPosts";

    await firestore.collection(collection).document(commentId).delete();
    commentsId.remove(commentId);
    await firestore.collection(collection=="commentsPosts" ? "posts" : "postsGroups").document(postId).updateData({'comments': commentsId});

}
        



  removePostGroup(String postName, String nameGroup) async {
    List<String> postsId = [];
    String uid = await inputData();
    await firestore.collection("postsGroups").document(postName).delete();

    final QuerySnapshot result = await firestore
        .collection("groups")
        .where('name', isEqualTo: nameGroup)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;

    List<dynamic> str1 = snapshot[0].data['posts'];
    for (int i = 0; i < str1.length; i++) {
      postsId.add(str1[i].toString());
    }

    postsId.remove(postName);
    await firestore
        .collection("groups")
        .document(nameGroup)
        .updateData({'posts': postsId});
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

  Future createNewPost(
    String op,
    String postText,
    List<File> postImageList,
    List<String> postId,
    String tag1,
    String tag2,
    String tag3,
  ) async {
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
    String collectionName = "";
    if (op == "createPost")
      collectionName = "posts";
    else if (op == "createCommentPost") collectionName = "commentsPosts";
    else if(op == "createCommentPostGroups")  collectionName = "commentsPostsGroups";

    String newCommentId = uid + '_' + now.toString();

    await firestore
        .collection(collectionName)
        .document(newCommentId)
        .setData(({
          'creationCountry': country,
          'creationRegion': administrativeArea,
          'creationSubRegion': subAdministrativeArea,
          'creationTime': now.toString(),
          'creatorUid': uid,
          'postId': postName,
          'text': postText,
          'tags': [tag1, tag2, tag3],
          'images': ['123456789', '123456789'],
          'likes': [],
          'comments': [],
        }))
        .whenComplete(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('postId', postName);

      final QuerySnapshot result = await firestore
        .collection("userData")
        .where('uid', isEqualTo: uid)
        .getDocuments();
     final List<DocumentSnapshot> snapshot = result.documents;
     List<dynamic> str1 = snapshot[0].data['posts'];
     List<String> str2 =  [];
     for(int i=0; i<str1.length ; i++){
      str2.add(str1[i].toString());
     }
     str2.add(postName); 
            
      await firestore
          .collection("userData")
          .document(uid)
          .updateData({'posts': str2});

    });

     

  }

  Future<bool> updatePostsComments(String op,String postId, String existingPostId) async {
    bool msg;
    String uid = await inputData();
    String collection= "";
    if(op=="createCommentPostGroups") collection = "postsGroups";  
    else collection = "posts";

    final QuerySnapshot result = await Firestore.instance
        .collection(collection)
        .where('postId', isEqualTo: existingPostId)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    List temp = snapshot[0].data['comments'];
    List<String> comments = [];
    for (int i = 0; i < temp.length; i++) {
      comments.add(temp[i].toString());
    }
    comments.add(postId);

    await firestore
        .collection(collection)
        .document(existingPostId)
        .updateData({'comments': comments});
    return true;
  }

  Future updateLikeListPost(String op, String postId, List<String> postLikes) async {
    
    String collection = op;
  
    await firestore
        .collection(collection)
        .document(postId)
        .updateData({'likes': postLikes});
  }

  Future createNewPostGroup(
    String postText,
    List<File> postImageList,
    List<String> postId,
    String tag1,
    String tag2,
    String tag3,
  ) async {
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
    final QuerySnapshot result = await Firestore.instance
        .collection('userData')
        .where('uid', isEqualTo: uid)
        .getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    String profileImage = snapshot[0].data['profileImages'][0].toString();
    String creatorName = snapshot[0].data['firstName'].toString() +
        "  " +
        snapshot[0].data['lastName'].toString();

    int now = new DateTime.now().millisecondsSinceEpoch;
    String postName = uid + '_' + now.toString();

    await firestore
        .collection("postsGroups")
        .document(postName)
        .setData(({
          'creatorUid': uid,
          'creatorName': creatorName,
          'profileImage': profileImage,
          'creationCountry': country,
          'creationRegion': administrativeArea,
          'creationSubRegion': subAdministrativeArea,
          'creationTime': now.toString(),
          'creatorUid': uid,
          'postId': postName,
          'text': postText,
          'tags': [tag1, tag2, tag3],
          'likes': [],
          'comments': [],
        }))
        .whenComplete(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('postId', postName);

      //postsId.add(postId);

      await firestore
          .collection("userData")
          .document(uid)
          .updateData({'posts': postsId});
    });
  }

  Future<List<String>> uploadPostImages(
      List<File> imageList, String postId) async {
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

  Future<List<String>> uploadPostGroupImages(
      List<File> imageList, String postId) async {
    List<String> imagesUrl = new List();
    String uid = await inputData();

    try {
      for (int s = 0; s < imageList.length; s++) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("postsGroups")
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

  Future<bool> updatePostsImages(
      String op, List<String> data, String postId, List<String> postsId) async {
    bool msg;
    String uid = await inputData();

    try {
      if (op == "createPost") {
        await firestore
            .collection("posts")
            .document(postId)
            .updateData({'images': data}).whenComplete(() {
          msg = true;
        });
      }
      else if(op == "createCommentPost"){
        await firestore .collection("commentsPosts").document(postId).updateData({'images': data}).whenComplete(() {
        msg = true;
      });
      }
      else if(op == "createCommentPostGroups"){
        await firestore .collection("commentsPostsGroups").document(postId).updateData({'images': data}).whenComplete(() {
        msg = true;
      });
      }

      postsId.add(postId);
      await firestore
          .collection("userData")
          .document(uid)
          .updateData({'posts': postsId});

      return msg;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<bool> updatePostsGroupsImages(String nameGroup, List<String> data,
      String postId, List<String> postsId) async {
    bool msg;
    String uid = await inputData();
    List<String> postsId = [];
    try {
      await firestore
          .collection("postsGroups")
          .document(postId)
          .updateData({'images': data}).whenComplete(() {
        msg = true;
      });

      final QuerySnapshot result = await firestore
          .collection("groups")
          .where('name', isEqualTo: nameGroup)
          .getDocuments();
      final List<DocumentSnapshot> snapshot = result.documents;

      List<dynamic> str1 = snapshot[0].data['posts'];
      for (int i = 0; i < str1.length; i++) {
        postsId.add(str1[i].toString());
      }

      postsId.add(postId);

      await firestore
          .collection("groups")
          .document(nameGroup)
          .updateData({'posts': postsId});

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
    List<String> blockedBy,
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
          'blockedBy': blockedBy,
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
