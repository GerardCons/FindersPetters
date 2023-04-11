import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/model/cart.dart';
import 'package:finderspetters/screens/veiwCart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Cart> _orders = [];
  final User user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('User Carts')
        .where('userEmail', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Cart.fromJson(doc.data());
        _orders.add(myOrder);
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 235, 227, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(186, 215, 98, 1),
        title:
            Padding(padding: const EdgeInsets.all(15), child: Text("Orders")),
      ),
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ViewCartScreen(
                            cartId: _orders[index].id,
                            storeId: _orders[index].storeId,
                            storeAddress: _orders[index].storeAddress,
                            storeName: _orders[index].storeName,
                            hasOrdered: _orders[index].hasOrdered,
                          )));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_orders[index].storeName),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text("(Items: ${_orders[index].products.length})"),
                        ],
                      ),
                      Spacer(),
                      (_orders[index].hasOrdered == true)
                          ? Text("Pending",
                              style: TextStyle(color: Colors.green))
                          : Text(
                              "In Cart",
                              style: TextStyle(color: Colors.red),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
