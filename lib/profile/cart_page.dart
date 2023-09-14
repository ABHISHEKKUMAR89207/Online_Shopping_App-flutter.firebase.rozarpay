import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_flutter_app/appDrawer.dart';
import 'package:my_flutter_app/profile/OrderHistoryPage.dart';
import 'package:my_flutter_app/shopping%20categoryvise/AcessItemList.dart';
import 'package:my_flutter_app/shopping%20categoryvise/ItemDetailScreen.dart';
import 'package:my_flutter_app/views/BottomNavigator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late Razorpay _razorpay;
  double totalAmount = 0.0;
  String deliveryAddress = '';
  @override
  void initState() {
    super.initState();
    _calculateAndUpdateTotalAmount();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("Payment success");

    var userData =
        await _firestore.collection('users').doc(currentUser!.uid).get();
    if (userData.exists) {
      var cartItems = List<String>.from(userData['cart']);

      // Loop through cart items to update stock and price
      for (var cartItemId in cartItems) {
        var cartItemSnapshot = await _firestore
            .collection('AllInOneShopping')
            .doc(cartItemId)
            .get();
        if (cartItemSnapshot.exists) {
          var cartItemData = cartItemSnapshot.data() as Map<String, dynamic>;

          // Update stock
          await _firestore
              .collection('AllInOneShopping')
              .doc(cartItemId)
              .update({
            'stock': cartItemData['stock'] - 1,
          });
        }
      }

      // Update the 'order' field with purchased items' document IDs
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'order': FieldValue.arrayUnion(cartItems),
      });

      // Clear the user's cart
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'cart': [],
        'totalcartamount': 0.0,
      });

      // Trigger a rebuild of the widget to reflect the changes
      setState(() {});
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    print("Payment error: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External wallet payment: ${response.walletName}");
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _calculateAndUpdateTotalAmount() async {
    var userData =
        await _firestore.collection('users').doc(currentUser!.uid).get();

    if (userData.exists) {
      var cartItems = List<String>.from(userData['cart']);

      for (var cartItemId in cartItems) {
        var cartItemSnapshot = await _firestore
            .collection('AllInOneShopping')
            .doc(cartItemId)
            .get();
        if (cartItemSnapshot.exists) {
          var cartItemData = cartItemSnapshot.data() as Map<String, dynamic>;
          totalAmount += cartItemData['price'];
        }
      }

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'totalcartamount': totalAmount,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 225, 187, 74),
        title: Text("Order Cart"),
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
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }

                List<dynamic> cartItems = [];
                if (snapshot.data!.exists) {
                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  if (userData.containsKey('cart')) {
                    cartItems = List<dynamic>.from(userData['cart']);
                  }
                }

                if (cartItems.isEmpty) {
                  return Center(child: Text('Your cart is empty.'));
                }

                return ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    String cartItemId = cartItems[index];

                    return FutureBuilder<DocumentSnapshot>(
                      future: _firestore
                          .collection('AllInOneShopping')
                          .doc(cartItemId)
                          .get(),
                      builder: (context, cartItemSnapshot) {
                        if (!cartItemSnapshot.hasData ||
                            cartItemSnapshot.data == null) {
                          return Center(child: CircularProgressIndicator());
                        }

                        var cartItemData = cartItemSnapshot.data!.data()
                            as Map<String, dynamic>;

                        double itemPrice = cartItemData['price'];

                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailScreen(
                                    ShoppingItem(
                                      cartItemData['name'],
                                      cartItemData['imagePath'],
                                      cartItemData['price'],
                                      cartItemData['rating'],
                                      cartItemData['shortDescription'],
                                      cartItemData['stock'],
                                    ),
                                    'AllInOneShopping',
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ListTile(
                                leading: Image.asset(
                                  cartItemData['imagePath'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(cartItemData['name']),
                                subtitle:
                                    Text(cartItemData['shortDescription']),
                                trailing:
                                    Text('\$${itemPrice.toStringAsFixed(2)}'),
                              ),
                            ));
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Show a dialog to update the address
                    _showUpdateAddressDialog();
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Text('Update Delivery Address'),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return SizedBox();
                    }

                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    deliveryAddress = userData.containsKey('address')
                        ? userData['address']
                        : 'No Address';

                    return Text(
                      'Delivery Address: $deliveryAddress',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Text('Total: \$0.00',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold));
                    }

                    double total = 0.0;
                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    if (userData.containsKey('totalcartamount')) {
                      total = userData['totalcartamount'];
                    }

                    return Text('Total: \$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold));
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    var options = {
                      'key': 'rozar pay api key',
                      'amount': (totalAmount * 100).toInt(),
                      'name': 'AK Trains',
                      'description': 'Pay the amount to book ticket',
                      'prefill': {
                        'contact': '8976567876',
                        'email': 'alb@gmail.com',
                      },
                    };

                    try {
                      _razorpay.open(options);
                    } catch (e) {
                      print("Error initiating payment: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.amber),
                  child: Text('Pay'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigatorExample(),
    );
  }

  // Function to show the update address dialog
  void _showUpdateAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedAddress = '';

        return AlertDialog(
          title: Text('Update Delivery Address'),
          content: TextFormField(
            onChanged: (value) {
              updatedAddress = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter your new delivery address',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog

                // Update the user's address in Firestore
                await _firestore
                    .collection('users')
                    .doc(currentUser!.uid)
                    .update({
                  'address': updatedAddress,
                });

                setState(() {
                  deliveryAddress = updatedAddress;
                });
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
