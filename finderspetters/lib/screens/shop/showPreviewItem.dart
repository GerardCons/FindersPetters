import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/model/cart.dart';
import 'package:finderspetters/screens/shop/shopCartScreen.dart';
import 'package:finderspetters/screens/shop/shopStoreScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PreviewItemScreen extends StatefulWidget {
  final String storeId;
  final String itemName;
  final int itemPrice;
  final String itemImage;
  final String itemDescription;
  final String storeName;
  final String storeAddress;

  const PreviewItemScreen(
      {super.key,
      required this.storeId,
      required this.itemName,
      required this.itemDescription,
      required this.itemImage,
      required this.itemPrice,
      required this.storeAddress,
      required this.storeName});

  @override
  State<PreviewItemScreen> createState() => _PreviewItemScreenState();
}

class _PreviewItemScreenState extends State<PreviewItemScreen> {
  final User user = FirebaseAuth.instance.currentUser!;
  var uuid = const Uuid();
  bool hasCart = false;
  String _uid = "";
  String cartId = "";
  List<String> existing_products = [];
  List<int> existing_prices = [];
  List<String> existing_productImages = [];
  List<String> existing_productDescriptions = [];
  List<int> existing_quantity = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 235, 227, 1),
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle the button press here
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ShopStoreScreen(
                      storeId: widget.storeId,
                    )));
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.itemImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.61,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child:
                        Text(widget.itemName, style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "₱${widget.itemPrice}",
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(widget.itemDescription,
                        style: TextStyle(fontSize: 14)),
                  ),
                  SizedBox(height: 250),
                  Center(child: loginButton(size)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell loginButton(Size size) {
    return InkWell(
      onTap: (() async {
        await checkHasCart();
        if (hasCart == true) {
          final cartData =
              FirebaseFirestore.instance.collection('User Carts').doc(cartId);

          existing_products.add(widget.itemName);
          existing_prices.add(widget.itemPrice);
          existing_productDescriptions.add(widget.itemDescription);
          existing_productImages.add(widget.itemImage);
          existing_quantity.add(1);

          final data = {
            'products': existing_products,
            'productImages': existing_productImages,
            'productPrices': existing_prices,
            'productDescriptions': existing_productDescriptions,
            'productQuantity': existing_quantity
          };

          cartData.update(data);
        } else {
          print(hasCart);
          print("new cart");
          _uid = uuid.v4();
          cartId = _uid;
          final cartData =
              FirebaseFirestore.instance.collection('User Carts').doc(_uid);

          List<String> products = [];
          List<int> prices = [];
          List<String> productImages = [];
          List<String> productDescriptions = [];
          List<int> quantity = [];
          products.add(widget.itemName);
          prices.add(widget.itemPrice);
          productImages.add(widget.itemImage);
          productDescriptions.add(widget.itemDescription);
          quantity.add(1);

          final data = {
            'id': _uid,
            'hasOrdered': false,
            'orderedDate': null,
            'storeId': widget.storeId,
            'storeName': widget.storeName,
            'storeAddress': widget.storeAddress,
            'userEmail': user.email,
            'products': products,
            'productImages': productImages,
            'productPrices': prices,
            'productDescriptions': productDescriptions,
            'productQuantity': quantity
          };
          cartData.set(data);
        }

        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ShopCartScreen(
                  cartId: cartId,
                  storeId: widget.storeId,
                  storeAddress: widget.storeAddress,
                  storeName: widget.storeName,
                )));
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
        child: const Text(
          "Add to Cart",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  checkHasCart() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User Carts')
        .where('userEmail', isEqualTo: user.email)
        .where('storeId', isEqualTo: widget.storeId)
        .where('hasOrdered', isEqualTo: false)
        .get();

    print(querySnapshot.docs.length);

    if (querySnapshot.docs.isNotEmpty) {
      print("getting cart info");
      hasCart = true;
      querySnapshot.docs.forEach((doc) {
        existing_products = doc['products'].cast<String>();
        existing_productImages = doc['productImages'].cast<String>();
        existing_prices = doc['productPrices'].cast<int>();
        existing_productDescriptions =
            doc['productDescriptions'].cast<String>();
        existing_quantity = doc['productQuantity'].cast<int>();
        cartId = doc.id;
      });
    }
  }
}
