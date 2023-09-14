import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_flutter_app/appDrawer.dart';
import 'package:my_flutter_app/profile/cart_page.dart';
import 'package:my_flutter_app/services/signUpServices.dart';
import 'package:my_flutter_app/views/BottomNavigator.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = "n/a";
  String _email = "n/a";
  String _address = "n/a";
  String _phoneNumber = "n/a";
  User? userId = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {}; 

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userDoc.exists) {
        return userDoc.data() ?? {}; // Return user data if it exists
      } else {
        return {}; // Return an empty map if the document does not exist
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {}; // Return an empty map in case of an error
    }
  }

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Map<String, dynamic> data = await getUserData(currentUser.uid);
      setState(() {
        userData = data; // Assign data to userData
        _name = data["username"];
        _email = data["userEmail"];
        _phoneNumber = data["userPhone"];
        _address = data["Address"];
      });
    }
  }

  // Functions to update user information
  void _updateName(String newName) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser
              .uid) // Update the document corresponding to the current user
          .update({'username': newName.trim()}).then((_) {
        setState(() {
          _name = newName;
        });
        log("Data updated successfully");
      }).catchError((error) {
        log("Error updating data: $error");
      });
    }
  }

  void _updateEmail(String newEmail) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser
              .uid) // Update the document corresponding to the current user
          .update({'userEmail': newEmail.trim()}).then((_) {
        setState(() {
          _email = newEmail;
        });
        log("Data updated successfully");
      }).catchError((error) {
        log("Error updating data: $error");
      });
    }
  }

  void _updateAddress(String newAddress) {
    setState(() {
      _address = newAddress;
    });
  }

  void _updatePhoneNumber(String newPhoneNumber) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser
              .uid) // Update the document corresponding to the current user
          .update({'userPhone': newPhoneNumber.trim()}).then((_) {
        setState(() {
          _phoneNumber = newPhoneNumber;
        });
        log("Data updated successfully");
      }).catchError((error) {
        log("Error updating data: $error");
      });
    }
    setState(() {
      _phoneNumber = newPhoneNumber;
    });
  }

  void _openEditModal(String initialValue, Function(String) onUpdate) {
    TextEditingController _controller =
        TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit"),
          content: TextField(controller: _controller),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onUpdate(_controller.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Returning 'false' will prevent the user from going back.
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 225, 187, 74),
          title: Text("Profile"),
          actions: [],
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/images.jpg'),
                ),
              ),
              SizedBox(height: 20),
              _buildInfoRow("Name:", _name, _updateName),
              _buildInfoRow("Email:", _email, _updateEmail),
              _buildInfoRow("Address:", _address, _updateAddress),
              _buildInfoRow("Phone Number:", _phoneNumber, _updatePhoneNumber),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Function(String) onUpdate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 124, 5, 110), // Custom text color
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 124, 5, 110), // Custom icon color
                ),
                onPressed: () {
                  _openEditModal(value, onUpdate);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
