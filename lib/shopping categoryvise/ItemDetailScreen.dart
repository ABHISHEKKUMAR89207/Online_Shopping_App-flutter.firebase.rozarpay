import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/appDrawer.dart';
import 'package:my_flutter_app/profile/cart_page.dart';
import 'package:my_flutter_app/shopping%20categoryvise/AcessItemList.dart';
import 'package:my_flutter_app/views/BottomNavigator.dart';

class ItemDetailScreen extends StatefulWidget {
  final ShoppingItem item;
  final String collection;

  ItemDetailScreen(this.item, this.collection);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  String newComment = "";
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? itemDetails;
  String itemId = "";

  @override
  void initState() {
    super.initState();
    getDocumentDetails();
  }

  Future<void> getDocumentDetails() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
        .collection(widget.collection)
        .where('name', isEqualTo: widget.item.name)
        .where('shortDescription', isEqualTo: widget.item.shortDescription)
        .get();

    if (snapshot.size == 1) {
      setState(() {
        itemDetails = snapshot.docs[0].data();
        itemId = snapshot.docs[0].id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 225, 187, 74),
        title: Text(widget.item.name),
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    widget.item.imagePath,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (itemDetails != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${itemDetails!['price'].toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (currentUser != null &&
                                          itemDetails != null) {
                                        // Add the item's document ID to the user's cart field
                                        await _firestore
                                            .collection('users')
                                            .doc(currentUser!.uid)
                                            .update({
                                          'cart': FieldValue.arrayUnion([
                                            itemId
                                          ]), // Add itemId to the array
                                        });
                                      } else {}
                                    },
                                    child: Text('Add to Cart'),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow),
                                  Text(itemDetails!['rating'].toString()),
                                  SizedBox(width: 16),
                                  Text(
                                    '${itemDetails!['stock']} left in stock',
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                itemDetails!['shortDescription'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Product Description',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  itemDetails!['description'],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Customer Comments',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Column(
                                children: (itemDetails!['comments']
                                        as List<dynamic>)
                                    .map((comment) => Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          padding: EdgeInsets.all(12.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Text(comment),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        if (itemDetails == null)
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Add a comment',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              newComment = value;
                            });
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (newComment.isNotEmpty) {
                              // Add the new comment to the comments array in the item's document
                              await _firestore
                                  .collection(widget.collection)
                                  .doc(itemId)
                                  .update({
                                'comments': FieldValue.arrayUnion([newComment]),
                              });

                              setState(() {
                                // Clear the input field after adding the comment
                                newComment = "";
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
        label: Text('Cart'),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: Color.fromARGB(255, 206, 160, 32),
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}
