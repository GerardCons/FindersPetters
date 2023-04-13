import 'package:finderspetters/auth/forgotPass.dart';
import 'package:finderspetters/components/googleButton.dart';
import 'package:finderspetters/components/passwordInput.dart';
import 'package:finderspetters/components/usernameInput.dart';
import 'package:finderspetters/components/utils.dart';
import 'package:finderspetters/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreenPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  LoginScreenPage({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

class _LoginScreenPageState extends State<LoginScreenPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
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
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Center(
                  child: Container(
                    height: 250,
                    width: 320,
                    child: Stack(
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(186, 215, 98, 1)),
                        ),
                        Positioned(
                          top: 60,
                          child: Text(
                            "Back!",
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(186, 215, 98, 1)),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Image(
                            image: AssetImage("assets/image/loginPhoto.png"),
                            height: 270,
                            width: 250,
                          ),
                        ),
                      ],
                    ),
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
                    hintText: "Email Address",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Center(
                      child: PasswordInput(
                    textEditingController: password,
                    hintText: "Password",
                  ))),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 180),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(
                              isLogin: "false",
                            )));
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              loginButton(size),
              const SizedBox(height: 20),
              RichText(
                  text: TextSpan(
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                      text: 'Don\'t have an account? ',
                      children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: 'Sign up here',
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

  InkWell loginButton(Size size) {
    return InkWell(
      onTap: (() {
        setState(() {
          isLoading = true;
        });
        signIn();
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
        child: (isLoading == true)
            ? const CircularProgressIndicator()
            : const Text(
                'LOGIN',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Future signIn() async {
    bool hasError = false;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username.text.trim(),
        password: password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.message!.isNotEmpty) {
        hasError = true;
        print(e.message);
        print(hasError);
      }
      if (e.message == "Given String is empty or null") {
        Utils.errorSnackBar(
            Icons.error, "Please input your username and password");
      } else {
        Utils.errorSnackBar(Icons.error, e.message.toString());
      }
    }
    if (hasError == false) {
      Future.delayed(const Duration(seconds: 5), () {
        isLoading = false;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserPage()));
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
