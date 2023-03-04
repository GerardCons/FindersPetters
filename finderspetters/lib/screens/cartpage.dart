import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(186, 215, 98, 1),
        title: Padding(
            padding: const EdgeInsets.all(15), child: Text("FindersPetters")),
      ),
      body: Container(),
    );
  }
}
