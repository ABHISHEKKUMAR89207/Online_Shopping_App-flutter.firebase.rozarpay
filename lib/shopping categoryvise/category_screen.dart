import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/appDrawer.dart';
import 'package:my_flutter_app/profile/cart_page.dart';
import 'package:my_flutter_app/shopping%20categoryvise/AcessItemList.dart';
import 'package:my_flutter_app/views/BottomNavigator.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  User? userId = FirebaseAuth.instance.currentUser;
  final List<String> categories = [
    'AllInOneShopping',
    'Electronics',
    'Clothing',
    'Books',
    'Beauty',
    'Sports',
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
          title: Text("Shopping Categories"),
          actions: [],
        ),
        drawer: AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color.fromARGB(255, 200, 164, 218),
                elevation: 4.0,
                child: ListTile(
                  title: Text(
                    categories[index],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    _navigateToCategoryPage(context, categories[index]);
                  },
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigatorExample(),
      ),
    );
  }

  void _navigateToCategoryPage(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Access_items(category),
      ),
    );
  }
}
