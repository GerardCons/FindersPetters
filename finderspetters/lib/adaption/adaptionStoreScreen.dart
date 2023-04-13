import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/adaption/adaptionScreen.dart';
import 'package:finderspetters/model/cart.dart';
import 'package:finderspetters/screens/grooming/googleMapLocation.dart';
import 'package:finderspetters/screens/shop/shopCartScreen.dart';
import 'package:finderspetters/screens/shop/shopStoreScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PreviewAdaptionScreen extends StatefulWidget {
  final String storeName;
  final String storeDescription;
  final String storeImage;
  final String storeLat;
  final String storeLong;
  final String storeAddress;

  const PreviewAdaptionScreen(
      {super.key,
      required this.storeName,
      required this.storeDescription,
      required this.storeImage,
      required this.storeLat,
      required this.storeLong,
      required this.storeAddress});

  @override
  State<PreviewAdaptionScreen> createState() => _PreviewAdaptionScreenState();
}

class _PreviewAdaptionScreenState extends State<PreviewAdaptionScreen> {
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AdaptionScreenWidget()));
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.storeImage),
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
                        Text(widget.storeName, style: TextStyle(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Address :${widget.storeAddress}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Text(widget.storeDescription,
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
      onTap: (() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RouteMapScreen(
              lat: widget.storeLat,
              long: widget.storeLong,
            ),
          ),
        );
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
          "Get Directions",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
