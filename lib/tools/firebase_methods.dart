import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class FirebaseMethods {
  Firestore firestore = Firestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

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

  Future<String> createUserAccount(
      {String firstName,
      String lastName,
      String phoneNumber,
      String birthDate,
      String academicField,
      String countryCity,
      String gender}) async {
    DocumentReference ref = await firestore.collection("userData").add({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'academicField': academicField,
      'countryCity': countryCity,
      'gender': gender,
    });
    print(ref.documentID);

    return ref.documentID;
  }

  Future<List<String>> uploadProductImages(
      {String docID, List<File> imageList}) async {
    List<String> imagesUrl = new List();

    try {
      for (int s = 0; s < imageList.length; s++) {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child("userData")
            .child(docID)
            .child(docID + ".$s.jpg");
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

  Future<bool> updateProductImages({String docID, List<String> data}) async {
    bool msg;

    try {
      await firestore
          .collection("userData")
          .document(docID)
          .updateData({'profileImages': data}).whenComplete(() {
        msg = true;
      });

      return msg;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
