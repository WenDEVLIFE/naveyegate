import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/FirebaseService.dart';

abstract class SubmitRepository {
  Future<void> submitReport({required String feedback});


}

class SubmitRepositoryImpl  extends SubmitRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> submitReport({required String feedback}) async {

    FirebaseAuth .instance.signInWithEmailAndPassword(
      email: FirebaseService.adminEmail,
      password: FirebaseService.adminPassword,
    ).then((value) async {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('reports').add({
          'feedback': feedback,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
        });
        print("Report submitted successfully");
        Fluttertoast.showToast(
          msg: "Report submitted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        print("No user is signed in");
      }
    }).catchError((error) {
      print("Failed to submit report: $error");
      Fluttertoast.showToast(
        msg: "Failed to submit report: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });

  }

}