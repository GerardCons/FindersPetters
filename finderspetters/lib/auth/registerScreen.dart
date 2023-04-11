import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/components/passwordInput.dart';
import 'package:finderspetters/components/usernameInput.dart';
import 'package:finderspetters/components/utils.dart';
import 'package:finderspetters/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class RegisterScreenPage extends StatefulWidget {
  final VoidCallback onClickedSignIn;
  RegisterScreenPage({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<RegisterScreenPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterScreenPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  var uuid = const Uuid();
  String _uid = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 235, 227, 1),
      body: SafeArea(
        child: SingleChildScrollView(
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
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: UsernameInput(
                    textEditingController: fullName,
                    hintText: "Full Name",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: UsernameInput(
                    textEditingController: username,
                    hintText: "Username",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: UsernameInput(
                    textEditingController: mobileNumber,
                    hintText: "Mobile Number",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: UsernameInput(
                    textEditingController: email,
                    hintText: "Email",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                      child: PasswordInput(
                    textEditingController: password,
                    hintText: "Password",
                  ))),
              const SizedBox(height: 20),
              RegisterButton(size),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                      text: 'Already have an account? ',
                      children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: 'Login',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.redAccent,
                        ))
                  ])),
            ],
          ),
        ),
      ),
    );
  }

  InkWell RegisterButton(Size size) {
    return InkWell(
      onTap: (() async {
        if (username.text.isEmpty ||
            password.text.isEmpty ||
            fullName.text.isEmpty ||
            mobileNumber.text.isEmpty ||
            username.text.isEmpty) {
          Utils.errorSnackBar(
              Icons.error, "Please complete all the requirements");
        } else {
          _uid = uuid.v4();
          final userData =
              FirebaseFirestore.instance.collection('User Profile').doc(_uid);

          final data = {
            'id': _uid,
            'email': email.text,
            'fullName': fullName.text,
            'mobileNumber': mobileNumber.text,
            'username': username.text,
          };
          userData.set(data);
          signUp();
        }
      }),
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
        child: const Text(
          'Sign Up',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => UserPage()));
    } on FirebaseAuthException catch (e) {
      if (e.message == "Given String is empty or null") {
        Utils.errorSnackBar(
            Icons.error, "Please input your username and password");
      } else {
        Utils.errorSnackBar(Icons.error, e.message.toString());
      }
    }
  }
}
