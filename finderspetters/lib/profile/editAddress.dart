import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/components/usernameInput.dart';
import 'package:finderspetters/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  final String profileId;
  final String currentAddress;
  MapScreen({Key? key, required this.profileId, required this.currentAddress})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  LatLng? _currentPosition;
  String _address = '';
  TextEditingController contact = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _getAddress(position.latitude, position.longitude);
  }

  Future<void> _getAddress(double lat, double lng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
    Placemark place = placemarks[0];
    setState(() {
      _address = '${place.name}, ${place.locality}, ${place.country}';
      contact.text = '${place.name}, ${place.locality}, ${place.country}';
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onTap(LatLng position) {
    setState(() {
      _currentPosition = position;
    });
    _getAddress(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
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
              padding: const EdgeInsets.all(15), child: Text("Edit Address")),
          actions: [
            TextButton(
                onPressed: () {
                  final userData = FirebaseFirestore.instance
                      .collection('User Profile')
                      .doc(widget.profileId);

                  final data = {
                    'address': contact.text,
                    'lat': _currentPosition!.latitude,
                    'long': _currentPosition!.longitude
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
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
            padding: const EdgeInsets.all(15), child: Text("Edit Address")),
        actions: [
          TextButton(
              onPressed: () {
                final userData = FirebaseFirestore.instance
                    .collection('User Profile')
                    .doc(widget.profileId);

                final data = {
                  'address': contact.text,
                  'lat': _currentPosition!.latitude,
                  'long': _currentPosition!.longitude
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
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onTap,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _currentPosition!,
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('Current Address: ${widget.currentAddress}'),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'New Address:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: TextFormField(
                    controller: contact,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: 12),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(249, 235, 227, 1),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
