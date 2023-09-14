// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/profile/userprofile.dart';
import 'package:my_flutter_app/services/signUpServices.dart';
import 'package:my_flutter_app/shopping%20categoryvise/category_screen.dart';
import 'package:my_flutter_app/views/HomeScreen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  User? userId = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userData = {}; // Declare userData at class level

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDataSnapshot.exists) {
        // Extract user data
        final Map<String, dynamic> userData =
            userDataSnapshot.data() as Map<String, dynamic>;
        return userData;
      } else {
        // Handle the case where user data does not exist
        return {};
      }
    } catch (error) {
      // Handle errors
      print('Error fetching user data: $error');
      return {};
    }
  }

  Future<void> fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Map<String, dynamic> data = await getUserData(currentUser.uid);
      setState(() {
        userData = data; // Assign data to userData
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: UserAccountsDrawerHeader(
              accountName: Text(
                '${userData['username'] ?? 'Loading...'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'User Email: ${userData['userEmail'] ?? 'Loading...'}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images.jpg'),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 124, 5, 110),
              ),
            ),
          ),
          _buildDrawerItem(Icons.person, 'Profile', ProfilePage()),
          _buildDrawerItem(Icons.home, 'Home', HomeScreen()),
          _buildDrawerItem(Icons.more_vert, 'Categories', CategoryScreen()),
          _buildDrawerItem(Icons.favorite, 'Favorites', HomeScreen()),
          _buildDrawerItem(Icons.settings, 'Settings', HomeScreen()),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
