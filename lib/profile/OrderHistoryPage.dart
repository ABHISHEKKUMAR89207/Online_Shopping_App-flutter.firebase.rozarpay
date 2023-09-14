import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_flutter_app/appDrawer.dart';
import 'package:my_flutter_app/profile/cart_page.dart';
import 'package:my_flutter_app/views/BottomNavigator.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<void> _showCancelConfirmationDialog(String orderedItemId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: SingleChildScrollView(
            child: Text('Are you sure you want to cancel this order?'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                await _cancelOrder(orderedItemId);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelOrder(String orderedItemId) async {
    // Remove item from the user's order
    await _firestore.collection('users').doc(currentUser!.uid).update({
      'order': FieldValue.arrayRemove([orderedItemId]),
    });

    // update stock quantity for the canceled item
    try {
      DocumentSnapshot itemSnapshot = await _firestore
          .collection('AllInOneShopping')
          .doc(orderedItemId)
          .get();
      if (itemSnapshot.exists) {
        var orderedItemData = itemSnapshot.data() as Map<String, dynamic>;
        int currentStock = orderedItemData['stock'] as int;

        print('Current stock: $currentStock');

        await _firestore
            .collection('AllInOneShopping')
            .doc(orderedItemId)
            .update({
          'stock': currentStock +
              1, // Increment the stock by 1 for the canceled item
        });

        print('Stock updated successfully.');
      } else {
        print('Item snapshot does not exist.');
      }
    } catch (e) {
      print('Error updating stock: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 225, 187, 74),
        title: Text("Your Orders"),
        actions: [],
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            _firestore.collection('users').doc(currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> orderedItems = userData.containsKey('order')
              ? List<String>.from(userData['order'])
              : [];

          var deliveryDate = userData['deliveryDate'] as String?;
          var deliveryAddress = userData['address'] as String?;

          if (orderedItems.isEmpty) {
            return Center(child: Text('You have no orders.'));
          }

          return ListView.builder(
            itemCount: orderedItems.length,
            itemBuilder: (context, index) {
              String orderedItemId = orderedItems[index];

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore
                    .collection('AllInOneShopping')
                    .doc(orderedItemId)
                    .get(),
                builder: (context, orderedItemSnapshot) {
                  if (!orderedItemSnapshot.hasData ||
                      orderedItemSnapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var orderedItemData =
                      orderedItemSnapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    leading: Image.asset(
                      orderedItemData['imagePath'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      orderedItemData['name'],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderedItemData['price'].toStringAsFixed(2),
                          style: TextStyle(
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Delivery Date: ${deliveryDate ?? "no date"}',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Delivery Address: ${deliveryAddress ?? "no address"}',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Adding cancel button
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showCancelConfirmationDialog(orderedItemId);
                      },
                      child: Text('Cancel Order'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }
}
