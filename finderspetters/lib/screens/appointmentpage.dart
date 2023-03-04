import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
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
