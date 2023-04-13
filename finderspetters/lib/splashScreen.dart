import 'package:finderspetters/auth/checkAuthentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2)).then((value) => Navigator.of(context)
        .pushReplacement(
            CupertinoPageRoute(builder: (ctx) => CheckAuthenticationPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(186, 215, 98, 1),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/image/fpLogo.png"),
                width: 300,
              ),
              SizedBox(height: 50),
              SpinKitFadingCircle(
                color: Colors.white,
                size: 40,
              )
            ],
          ),
        ));
  }
}
