import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/appDrawer.dart';
import 'package:my_flutter_app/profile/cart_page.dart';
import 'package:my_flutter_app/profile/userprofile.dart';
import 'package:my_flutter_app/shopping%20categoryvise/ItemDetailScreen.dart';
import 'package:my_flutter_app/shopping%20categoryvise/category_screen.dart';

import 'package:my_flutter_app/views/BottomNavigator.dart';
import 'package:my_flutter_app/views/HomeScreen.dart';

class Access_items extends StatefulWidget {
  final String category;

  Access_items(this.category);

  @override
  _Access_itemsState createState() => _Access_itemsState();
}

class _Access_itemsState extends State<Access_items> {
  List<ShoppingItem> filteredItems = [];

  @override
  void initState() {
    _loadAndFilterItems('');
    super.initState();
  }

  void _loadAndFilterItems(String query) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection(widget.category).get();

    setState(() {
      filteredItems = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ShoppingItem(
          data['name'],
          data['imagePath'],
          data['price'],
          data['rating'],
          data['shortDescription'],
          data['stock'],
        );
      }).toList();

      if (query.isNotEmpty) {
        filteredItems = filteredItems
            .where(
                (item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _filterItems(String query) {
    if (query.isEmpty) {
      _loadAndFilterItems('');
    } else {
      _loadAndFilterItems(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 225, 187, 74),
        title: Text(widget.category),
        actions: [
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterItems,
              decoration: InputDecoration(
                labelText: 'Search for items',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToDetailScreen(item, widget.category);
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            item.imagePath,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                'assets/item.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name),
                              Text(item.shortDescription),
                              Text('\$${item.price.toStringAsFixed(2)}'),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow),
                                  Text(item.rating.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }

  void _navigateToDetailScreen(ShoppingItem item, String collection_name) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ItemDetailScreen(item, collection_name)),
    );
  }
}

class ShoppingItem {
  final String name;
  final String imagePath;
  final double price;
  final double rating;
  final double stock;
  final String shortDescription;

  ShoppingItem(this.name, this.imagePath, this.price, this.rating,
      this.shortDescription, this.stock);
}
