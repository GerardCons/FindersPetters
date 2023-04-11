import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/model/profile.dart';
import 'package:finderspetters/screens/grooming/groomingScreen.dart';
import 'package:finderspetters/screens/homepage.dart';
import 'package:finderspetters/screens/successAppointment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class viewBookings extends StatefulWidget {
  final String selectedTime;
  final String petkind;
  final List<String> services;
  final DateTime selectedDate;
  final String clinicName;
  final String clinicId;
  final String clinicAddress;
  const viewBookings(
      {Key? key,
      required this.selectedTime,
      required this.petkind,
      required this.services,
      required this.clinicAddress,
      required this.clinicId,
      required this.clinicName,
      required this.selectedDate});

  @override
  _viewBookingsState createState() => _viewBookingsState();
}

class _viewBookingsState extends State<viewBookings> {
  final User user = FirebaseAuth.instance.currentUser!;
  var uuid = const Uuid();
  String uid = "";
  bool isSent = false;
  String formattedTime = "";
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
          "Booking Overview",
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
              child: StreamBuilder<List<Profile>>(
                  stream: readProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something Went Wrong ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final users = snapshot.data!;
                      String formattedDate = DateFormat('EEEE, MMMM d y')
                          .format(widget.selectedDate);

                      DateTime time =
                          DateFormat('HH:mm').parse(widget.selectedTime);

                      formattedTime = DateFormat('h:mm a').format(time);
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 17),
                              child: Text(
                                widget.clinicName,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17, right: 105),
                              child: Text(
                                widget.clinicAddress,
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
                              endIndent:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 17),
                              child: Row(
                                children: [
                                  Text(
                                    "Name: ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    users.first.fullName,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17, right: 105),
                              child: Text(
                                "Appointment Date",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 37),
                              child: Text(
                                "- ${formattedDate}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17, right: 105),
                              child: Text(
                                "Schedule",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 37),
                              child: Text(
                                "- ${formattedTime}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17, right: 105),
                              child: Text(
                                "Pet",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 37),
                              child: Text(
                                "- ${widget.petkind}",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17, right: 105),
                              child: Text(
                                "Service",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 37),
                                child: ListView.builder(
                                  itemCount: widget.services.length,
                                  itemBuilder: (context, index) {
                                    final petService = widget.services[index];
                                    return Text(
                                      petService,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ]);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ),
          SizedBox(height: 20),
          loginButton(size),
        ],
      ),
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
          "Back to homepage",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Stream<List<Profile>> readProfile() {
    print(user.email);
    return FirebaseFirestore.instance
        .collection('User Profile')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['email'].toString().contains(user.email.toString()))
            .map((doc) => Profile.fromJson(doc.data()))
            .toList());
  }
}
