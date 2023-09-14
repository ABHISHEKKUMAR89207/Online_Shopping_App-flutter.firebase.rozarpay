import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:my_flutter_app/services/signUpServices.dart';
import 'package:my_flutter_app/views/SignInScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  String errorMessage = '';
  final RegExp passwordValidator = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!])(?=.{8,})',
  );

  // Define the allowed email domains list here
  final List<String> allowedEmailDomains = ['gmail.com', 'yahoo.com'];

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
          "SIGNUP SCREEN",
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
                height: 250,
                child: Lottie.asset("assets/animation_lm0r4ll7.json"),
              ),
              buildTextField(
                controller: userNameController,
                hintText: 'Username',
                prefixIcon: Icons.person,
              ),
              SizedBox(
                height: 6,
              ),
              buildPhoneTextField(
                controller: userPhoneController,
                hintText: 'Phone',
                prefixIcon: Icons.phone,
              ),
              SizedBox(
                height: 6,
              ),
              buildEmailTextField(
                controller: userEmailController,
                hintText: 'Email (only @gmail.com or @yahoo.com)',
                prefixIcon: Icons.email,
              ),
              SizedBox(
                height: 6,
              ),
              buildPasswordField(
                controller: userPasswordController,
                hintText: 'Password',
                prefixIcon: Icons.password,
              ),
              SizedBox(
                height: 6,
              ),
              buildTextField(
                controller: addressController,
                hintText: 'Address',
                prefixIcon: Icons.home,
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
                    var userName = userNameController.text.trim();
                    var userPhone = userPhoneController.text.trim();
                    var userEmail = userEmailController.text.trim();
                    var userPassword = userPasswordController.text.trim();
                    var address = addressController.text.trim();
                    final emailDomain = userEmail.split('@').last;

                    // Check phone number length
                    if (userPhone.length != 10) {
                      setState(() {
                        errorMessage = 'Phone number must be 10 digits.';
                      });
                      return;
                    }

                    // Check if the email domain is allowed
                    if (!allowedEmailDomains.contains(emailDomain)) {
                      setState(() {
                        errorMessage =
                            'Please use only "@gmail.com" or "@yahoo.com" email addresses.';
                      });
                      return;
                    }
                    if (!passwordValidator.hasMatch(userPassword)) {
                      setState(() {
                        errorMessage =
                            'Password must be at least 8 characters long and contain lowercase, uppercase, numbers, and special characters.';
                      });
                      return;
                    }
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: userEmail, password: userPassword)
                        .then((value) => {
                              log("user created"),
                              signUpUser(userName, userPhone, userEmail,
                                  userPassword, address)
                            });
                  },
                  child: Text(
                    "SignUp",
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
                  Get.to(() => LogineScreen());
                },
                child: Container(
                  child: Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Already Have an Account",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 23, 7)),
                    ),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return Container(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: Color.fromARGB(255, 43, 30, 181),
          ),
          suffixIcon: Icon(
            prefixIcon,
            color: Color.fromARGB(255, 43, 30, 181),
          ),
          hintText: hintText,
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
    );
  }

  Widget buildPhoneTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return Container(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: Color.fromARGB(255, 40, 181, 30),
          ),
          suffixIcon: Icon(
            prefixIcon,
            color: Color.fromARGB(255, 40, 181, 30),
          ),
          hintText: hintText,
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
          // Hide the counter text
          counterText: '',
        ),
      ),
    );
  }

  Widget buildEmailTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return Container(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: Color.fromARGB(255, 144, 43, 172),
          ),
          suffixIcon: Icon(
            prefixIcon,
            color: Color.fromARGB(255, 144, 43, 172),
          ),
          hintText: hintText,
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
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return Container(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(
            prefixIcon,
            color: Color.fromARGB(255, 193, 182, 26),
          ),
          suffixIcon: Icon(
            Icons.visibility_off,
            color: Color.fromARGB(255, 193, 182, 26),
          ),
          hintText: hintText,
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
    );
  }
}
