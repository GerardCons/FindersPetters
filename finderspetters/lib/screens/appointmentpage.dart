import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/model/booking.dart';
import 'package:finderspetters/viewBookin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final List<Booking> _books = [];
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('User Bookings')
        .where('userEmail', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myOrder = Booking.fromJson(doc.data());
        _books.add(myOrder);
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
        title: Padding(
            padding: const EdgeInsets.all(15), child: Text("Appointments")),
      ),
      body: ListView.builder(
        itemCount: _books.length,
        itemBuilder: (BuildContext context, int index) {
          String formattedDate = DateFormat('EEEE, MMMM d y')
              .format(_books[index].appointmentDate.toDate());
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => viewBookings(
                        selectedTime: _books[index].time,
                        clinicAddress: _books[index].storeAddress,
                        clinicName: _books[index].storeName,
                        clinicId: _books[index].storeId,
                        petkind: _books[index].petKind,
                        services: _books[index].services,
                        selectedDate: _books[index].appointmentDate.toDate(),
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(_books[index].storeName),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text("Schedule: ${_books[index].time}",
                                  style: TextStyle(color: Colors.green)),
                            ],
                          ),
                          Spacer(),
                          Text("Date: ${formattedDate}",
                              style: TextStyle(color: Colors.green))
                        ],
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
