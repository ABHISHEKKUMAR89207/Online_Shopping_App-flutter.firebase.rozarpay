// ignore_for_file: prefer_const_constructors, file_names, avoid_unnecessary_containers, duplicate_ignore, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/views/SignInScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController forgotPasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 8, 83, 112),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
        centerTitle: true,
        title: const Text(
          "FORGOT PASSWORD",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [Icon(Icons.more_vert)],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 300,
                child: Lottie.asset("assets/animation_lm0r4ll7.json"),
              ),
              Container(
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: forgotPasswordcontroller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 114, 215, 134),
                    ),
                    suffixIcon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 114, 215, 134),
                    ),
                    hintText: 'Email',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var forgotEmail = forgotPasswordcontroller.text.trim();
                    try {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: forgotEmail)
                          .then((value) => {
                                print("email send"),
                                Get.off(() => LogineScreen())
                              });
                    } on FirebaseAuthException catch (e) {
                      print("error $e");
                    }
                  },
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 101, 96, 23)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
