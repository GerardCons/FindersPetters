import 'package:finderspetters/screens/homepage.dart';
import 'package:flutter/material.dart';

class SuccessAppointmentPage extends StatefulWidget {
  const SuccessAppointmentPage({super.key});

  @override
  State<SuccessAppointmentPage> createState() => _SuccessAppointmentPageState();
}

class _SuccessAppointmentPageState extends State<SuccessAppointmentPage> {
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
              image: AssetImage("assets/image/successAppointment.png"),
              width: 300,
            ),
          ),
          Center(
              child: Text("Appointment",
                  style: TextStyle(fontSize: 40, color: Colors.white))),
          Center(
              child: Text("Sent!",
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
