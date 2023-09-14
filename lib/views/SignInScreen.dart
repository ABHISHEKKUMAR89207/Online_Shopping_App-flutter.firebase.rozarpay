// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, duplicate_ignore, file_names, unused_local_variable, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/views/ForgotPasswordScreen.dart';
import 'package:my_flutter_app/views/HomeScreen.dart';
import 'package:my_flutter_app/views/SignUpScreen.dart';

class LogineScreen extends StatefulWidget {
  const LogineScreen({Key? key}) : super(key: key);

  @override
  State<LogineScreen> createState() => _LogineScreenState();
}

class _LogineScreenState extends State<LogineScreen> {
  TextEditingController logineEmailController = TextEditingController();
  TextEditingController loginePasswordController = TextEditingController();

  bool isPasswordVisible = false;

  final List<String> allowedEmailDomains = ['gmail.com', 'yahoo.com'];

  String errorMessage = '';

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
          "LOGIN",
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
                  controller: logineEmailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 43, 30, 181),
                    ),
                    suffixIcon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 43, 30, 181),
                    ),
                    hintText: 'Email',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blue), // Border color
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.blue), // Focused border color
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey, // Hint text color
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: loginePasswordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: Color.fromARGB(255, 67, 194, 61),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromARGB(255, 142, 200, 80)),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    hintText: 'Password',
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
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var logineEmail = logineEmailController.text.trim();
                    var loginePassword = loginePasswordController.text.trim();
                    final emailDomain = logineEmail.split('@').last;
                    if (!allowedEmailDomains.contains(emailDomain)) {
                      //  error message for invalid email domain
                      setState(() {
                        errorMessage =
                            'Please use only "@gmail.com" or "@yahoo.com" email addresses.';
                      });
                      return;
                    }
                    try {
                      final User? firebaseUser = (await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: logineEmail, password: loginePassword))
                          .user;
                      if (firebaseUser != null) {
                        Get.to(() => HomeScreen());
                      } else {
                        // Display an error SnackBar for Incorrect Email or Password.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Incorrect Email or Password.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      // Handle FirebaseAuth exceptions and display an error SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Incorrect Email or Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 167, 29)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => ForgotPasswordScreen());
                },
                child: Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 6, 23, 7)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => SignUpScreen());
                },
                child: Container(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 6, 23, 7)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
