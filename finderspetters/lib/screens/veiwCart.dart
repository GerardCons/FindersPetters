import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/model/cart.dart';
import 'package:finderspetters/model/profile.dart';
import 'package:finderspetters/screens/homepage.dart';
import 'package:finderspetters/screens/shop/shopStoreScreen.dart';
import 'package:finderspetters/screens/successOrder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewCartScreen extends StatefulWidget {
  final String cartId;
  final String storeId;
  final String storeName;
  final String storeAddress;
  final bool hasOrdered;
  const ViewCartScreen(
      {Key? key,
      required this.cartId,
      required this.storeId,
      required this.storeAddress,
      required this.hasOrdered,
      required this.storeName});

  @override
  _ViewCartScreenState createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {
  final User user = FirebaseAuth.instance.currentUser!;
  bool isSent = false;
  double totalPrice = 0.0;
  double totalAmount = 0.0;
  List<String> products = [];
  List<int> productPrices = [];
  List<int> productInitialPrices = [];
  List<int> productQuantity = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('User Carts')
        .doc(widget.cartId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        final cart = Cart.fromJson(docSnapshot.data() ?? {});
        products = cart.products;
        productPrices = cart.productPrice;
        productInitialPrices = List.from(productPrices);
        productQuantity = cart.quantity;
        print(productPrices);
        getTotalAmount();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 235, 227, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(249, 235, 227, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => UserPage()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          "Checkout",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Text(
                        widget.storeName,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(left: 17, right: 105),
                      child: Text(
                        widget.storeAddress,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 2.0,
                      indent: MediaQuery.of(context).size.width * 0.05,
                      endIndent: MediaQuery.of(context).size.width * 0.05,
                    ),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  child: DropdownButton<int>(
                                    value: productQuantity[index],
                                    items: _numberItems(),
                                    menuMaxHeight: 50,
                                    onChanged: null,
                                    underline: Container(),
                                  ),
                                ),
                                Text(
                                  products[index],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Spacer(),
                                Text(
                                    '\₱${productPrices[index].toStringAsFixed(2)}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                      thickness: 2.0,
                      indent: MediaQuery.of(context).size.width * 0.05,
                      endIndent: MediaQuery.of(context).size.width * 0.05,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Subtotal:",
                          ),
                          Spacer(),
                          Text('\₱${totalPrice.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Deliver Fee:",
                          ),
                          Spacer(),
                          Text('₱50'),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                      thickness: 2.0,
                      indent: MediaQuery.of(context).size.width * 0.05,
                      endIndent: MediaQuery.of(context).size.width * 0.05,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Total:",
                          ),
                          Spacer(),
                          Text('\₱${totalAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    (widget.hasOrdered == true)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Status:",
                                ),
                                Spacer(),
                                Text(
                                  'Pending',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Status:",
                                ),
                                Spacer(),
                                Text(
                                  'In Cart',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                  ]),
            ),
          ),
          SizedBox(height: 20),
          backToStore(size),
        ],
      ),
    );
  }

  void getTotalAmount() {
    print(productInitialPrices);
    print(productPrices);
    totalPrice = 0;
    for (int i = 0; i < products.length; i++) {
      totalPrice = totalPrice + productPrices[i];
    }
    totalAmount = totalPrice + 50;
  }

  List<DropdownMenuItem<int>> _numberItems() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 1; i <= 50; i++) {
      items.add(
        DropdownMenuItem(
          child: Text('$i'),
          value: i,
        ),
      );
    }
    return items;
  }

  InkWell backToStore(Size size) {
    return InkWell(
      onTap: (() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserPage()));
      }),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.7,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromRGBO(255, 160, 55, 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: (isSent == true)
            ? const CircularProgressIndicator()
            : const Text(
                "Back to home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
