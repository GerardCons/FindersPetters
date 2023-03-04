import 'package:finderspetters/auth/authPage.dart';
import 'package:finderspetters/auth/loginScreen.dart';
import 'package:finderspetters/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckAuthenticationPage extends StatefulWidget {
  CheckAuthenticationPage({Key? key}) : super(key: key);

  @override
  State<CheckAuthenticationPage> createState() =>
      _CheckAuthenticationPageState();
}

class _CheckAuthenticationPageState extends State<CheckAuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Something Went Wrong: ${snapshot.hasError}'));
          } else if (snapshot.hasData) {
            return UserPage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
