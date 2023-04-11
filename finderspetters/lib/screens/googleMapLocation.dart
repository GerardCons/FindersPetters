import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapLocation extends StatefulWidget {
  final double lat;
  final double long;

  GoogleMapLocation({required this.lat, required this.long});

  @override
  _GoogleMapLocationState createState() => _GoogleMapLocationState();
}

class _GoogleMapLocationState extends State<GoogleMapLocation> {
  GoogleMapController? googleMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grooming'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GoogleMap(
        buildingsEnabled: false,
        zoomControlsEnabled: true,
        initialCameraPosition:
            CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 16),
        markers: Set<Marker>.from([
          Marker(
            markerId: MarkerId('location'),
            position: LatLng(widget.lat, widget.long),
          )
        ]),
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
    );
  }
}
