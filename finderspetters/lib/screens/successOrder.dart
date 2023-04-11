import 'package:finderspetters/screens/homepage.dart';
import 'package:flutter/material.dart';

class SuccessOrderPage extends StatefulWidget {
  const SuccessOrderPage({super.key});

  @override
  State<SuccessOrderPage> createState() => _SuccessOrderPageState();
}

class _SuccessOrderPageState extends State<SuccessOrderPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(186, 215, 98, 1),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image(
              image: AssetImage("assets/image/successOrder.png"),
              width: 300,
            ),
          ),
          Center(
              child: Text("Order",
                  style: TextStyle(fontSize: 40, color: Colors.white))),
          Center(
              child: Text("Placed!",
                  style: TextStyle(fontSize: 40, color: Colors.white))),
          SizedBox(height: 60),
          Center(child: loginButton(size))
        ],
      )),
    );
  }

  InkWell loginButton(Size size) {
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
        child: const Text(
          "Back to Homepage",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
