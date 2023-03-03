import 'package:finderspetters/auth/loginScreen.dart';
import 'package:finderspetters/auth/registerScreen.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreenPage(onClickedSignUp: toggle)
      : RegisterScreenPage(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
