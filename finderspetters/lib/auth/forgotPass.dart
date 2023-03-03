import 'package:finderspetters/components/usernameInput.dart';
import 'package:finderspetters/components/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController username = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(249, 235, 227, 1),
        foregroundColor: Color.fromRGBO(186, 215, 98, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text('Reset Password'),
      ),
      backgroundColor: Color.fromRGBO(249, 235, 227, 1),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: Container(
                  height: 129,
                  width: 320,
                  child: Stack(
                    children: [
                      Text(
                        "Getting",
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(186, 215, 98, 1)),
                      ),
                      Positioned(
                        top: 60,
                        child: Text(
                          "Started",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(186, 215, 98, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            const Text(
              'Receive an email to\nreset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: UsernameInput(
                  textEditingController: username,
                  hintText: "Email Address",
                ),
              ),
            ),
            SizedBox(height: 30),
            RegisterButton(size),
          ],
        ),
      ),
    );
  }

  InkWell RegisterButton(Size size) {
    return InkWell(
      onTap: (() {}),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromRGBO(255, 160, 55, 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: (isLoading == true)
            ? const CircularProgressIndicator()
            : const Text(
                'Reset Password',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future sendPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: username.text.trim(),
      );
      Utils.errorSnackBar(Icons.check, 'Password Reset Email Sent');
    } on FirebaseAuthException catch (e) {
      if (e.message == "Given String is empty or null") {
        Utils.errorSnackBar(Icons.error, "Please input your username");
      } else {
        Utils.errorSnackBar(Icons.error, e.message.toString());
      }
    }

    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
