import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/adaption/adaptionScreen.dart';
import 'package:finderspetters/screens/appointmentpage.dart';
import 'package:finderspetters/screens/cartpage.dart';
import 'package:finderspetters/screens/clinic/clinicScreen.dart';
import 'package:finderspetters/screens/grooming/groomingScreen.dart';
import 'package:finderspetters/profile/profilepage.dart';
import 'package:finderspetters/screens/shop/shopscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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
        color: Color.fromRGBO(249, 235, 227, 1),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green, // Set the border color here
                  width: 1, // Set the border width here
                ),
                borderRadius: BorderRadius.circular(16)),
            child: GNav(
                selectedIndex: index,
                color: Colors.black,
                activeColor: Colors.black,
                tabBackgroundColor: Color.fromRGBO(249, 235, 227, 1),
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
  bool isloaded = false;
  int index = 0;
  final User users = FirebaseAuth.instance.currentUser!;
  String fullName = "";
  String address = "";
  @override
  void initState() {
    super.initState();
    checkPermission();
    _getAddressFromLatLong();
    _neverSatisfied();
  }

  Future<void> checkPermission() async {
    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.status;
    if (permissionStatus != PermissionStatus.granted) {
      // Request permission to access location data
      permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus != PermissionStatus.granted) {
        // Handle the case where the user has declined to grant permission
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  Future<void> _getAddressFromLatLong() async {
    Position position = await _determinePosition();
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    setState(() {
      address = '${place.name}, ${place.locality}, ${place.country}';
      print(address);
      isloaded = true;
    });
  }

  Future<void> _neverSatisfied() async {
    final clinicData = await FirebaseFirestore.instance
        .collection('User Profile')
        .where('email', isEqualTo: users.email)
        .get();

    for (var doc in clinicData.docs) {
      Map<String, dynamic> data = doc.data();
      fullName = data['fullName'];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return (isloaded == true)
        ? Scaffold(
            backgroundColor: Color.fromRGBO(249, 235, 227, 1),
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(186, 215, 98, 1),
              title: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("FindersPetters")),
              elevation: 0,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width,
                  height: 180,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(186, 215, 98, 1),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Location',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  address,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Text(
                            "Hello, ${fullName}!",
                            style: TextStyle(fontSize: 22),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(left: 50, top: 5),
                          child: Text(
                            "What are you looking for today?",
                            style: TextStyle(fontSize: 18),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (isloaded == true) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShopScreenWidget()));
                                }
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/image/shop.png"),
                                foregroundColor: Colors.black,
                                radius: 50,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Shops',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (isloaded == true) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ClinicScreenWidget()));
                                }
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/image/clinic.png"),
                                foregroundColor: Colors.black,
                                radius: 50,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Clinics',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (isloaded == true) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GroomingScreenWidget()));
                                }
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/image/grooming.png"),
                                foregroundColor: Colors.black,
                                radius: 50,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Grooming',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdaptionScreenWidget()));
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/image/adaption.png"),
                                radius: 50,
                                foregroundColor: Colors.black,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Adoption',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ))
        : Scaffold(
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
