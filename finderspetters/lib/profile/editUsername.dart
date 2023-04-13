import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/components/usernameInput.dart';
import 'package:finderspetters/model/booking.dart';
import 'package:finderspetters/model/profile.dart';
import 'package:finderspetters/screens/homepage.dart';
import 'package:finderspetters/viewBookin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditUsernamePage extends StatefulWidget {
  final String username;
  final String profileId;
  EditUsernamePage({Key? key, required this.username, required this.profileId})
      : super(key: key);

  @override
  State<EditUsernamePage> createState() => _EditUsernamePageState();
}

class _EditUsernamePageState extends State<EditUsernamePage> {
  final List<Profile> _profile = [];
  final User user = FirebaseAuth.instance.currentUser!;
  TextEditingController username = TextEditingController();

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('User Profile')
        .where('email', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final myProfile = Profile.fromJson(doc.data());
        _profile.add(myProfile);
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
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => UserPage()));
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: Color.fromRGBO(186, 215, 98, 1),
          title: Padding(
              padding: const EdgeInsets.all(15), child: Text("Edit Username")),
          actions: [
            TextButton(
                onPressed: () {
                  final userData = FirebaseFirestore.instance
                      .collection('User Profile')
                      .doc(widget.profileId);

                  final data = {
                    'username': username.text,
                  };
                  userData.update(data);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => UserPage()));
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.green),
                ))
          ],
        ),
        body: Column(children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Center(
              child: UsernameInput(
                textEditingController: username,
                hintText: widget.username,
              ),
            ),
          ),
        ]));
  }
}
