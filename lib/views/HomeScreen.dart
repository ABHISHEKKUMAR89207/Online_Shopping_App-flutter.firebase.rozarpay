import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:my_flutter_app/appDrawer.dart';
import 'package:my_flutter_app/profile/OrderHistoryPage.dart';
import 'package:my_flutter_app/profile/cart_page.dart';
import 'package:my_flutter_app/shopping%20categoryvise/AcessItemList.dart';
import 'package:my_flutter_app/views/BottomNavigator.dart';
import 'package:my_flutter_app/views/SignInScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? userId = FirebaseAuth.instance.currentUser;
  final List<String> topDeals = [
    'assets/sale1.jpg',
    'assets/sale2.jpg',
    'assets/sale3.jpg',
  ];

  final List<String> offer = [
    'assets/offer1.jpg',
    'assets/offer2.jpg',
    'assets/offer3.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 225, 187, 74),
          title: Text("AK Mart"),
          actions: [
            IconButton(
              icon: Icon(Icons.delivery_dining),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryPage()),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
              child: Icon(Icons.logout),
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: Container(
          color: Color.fromARGB(255, 37, 36, 36),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CarouselSlider(
                  items: topDeals.map((imageUrl) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Access_items("AllInOneShopping")),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          color: Colors.grey,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Image.asset(imageUrl),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),

                SizedBox(height: 8),
                CarouselSlider(
                  items: offer.map((imageUrl) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Access_items("AllInOneShopping")),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          color: Colors.grey,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Image.asset(imageUrl),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),
                CarouselSlider(
                  items: topDeals.map((imageUrl) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Access_items("AllInOneShopping")),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          color: Colors.grey,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Image.asset(imageUrl),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),

                SizedBox(height: 8),
                CarouselSlider(
                  items: topDeals.map((imageUrl) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Access_items("AllInOneShopping")),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          color: Colors.grey,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Image.asset(imageUrl),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 250,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),

                SizedBox(height: 8),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Container(),
                // Add more widgets here
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(),
      ),
    );
  }
}

void _showLogoutConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Logout",
          style: TextStyle(color: Colors.amber),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(color: Colors.orange),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.green),
            ),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogineScreen()),
              );
            },
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
