// ignore_for_file: avoid_print, prefer_const_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:my_flutter_app/views/SignInScreen.dart';

signUpUser(String userName, String userPhone, String userEmail,
    String userPassword, String address) async {
  User? userid = FirebaseAuth.instance.currentUser;
  try {
    await FirebaseFirestore.instance.collection("users").doc(userid!.uid).set({
      'username': userName,
      'userPhone': userPhone,
      'userEmail': userEmail,
      'createdAt': DateTime.now(),
      'userId': userid.uid,
      'Address': address,
    }).then((value) => {
          FirebaseAuth.instance.signOut(),
          Get.to(() => LogineScreen()),
        });
  } on FirebaseAuthException catch (e) {
    print("error $e");
  }
}
