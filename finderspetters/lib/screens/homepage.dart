import 'package:finderspetters/screens/appointmentpage.dart';
import 'package:finderspetters/screens/cartpage.dart';
import 'package:finderspetters/screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int index = 0;
  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> screen = [
    UserHomepage(),
    CartPage(),
    AppointmentPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: GNav(
              selectedIndex: index,
              color: Colors.black,
              activeColor: Colors.black,
              tabBackgroundColor: Colors.white,
              gap: 8,
              padding: const EdgeInsets.all(16),
              onTabChange: (value) {
                setState(() {
                  index = value;
                });
              },
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                  onPressed: () {},
                ),
                GButton(
                  icon: Icons.shopping_cart,
                  text: 'Cart',
                  onPressed: () {},
                ),
                GButton(
                  icon: Icons.calendar_today,
                  text: 'Appointment',
                  onPressed: () {},
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Account',
                  onPressed: () {},
                ),
              ]),
        ),
      ),
      body: screen[index],
    );
  }
}

class UserHomepage extends StatefulWidget {
  UserHomepage({Key? key}) : super(key: key);

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(186, 215, 98, 1),
          title: Padding(
              padding: const EdgeInsets.all(15), child: Text("FindersPetters")),
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   width: size.width,
            //   height: 150,
            //   decoration: BoxDecoration(
            //       color: Color.fromRGBO(186, 215, 98, 1),
            //       borderRadius: BorderRadius.only(
            //           bottomLeft: Radius.circular(30),
            //           bottomRight: Radius.circular(30))),
            // ),
          ],
        ));
  }
}
