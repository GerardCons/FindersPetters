import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class RouteMapScreen extends StatefulWidget {
  final String lat;
  final String long;

  RouteMapScreen({required this.lat, required this.long});

  @override
  _RouteMapScreenState createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndRoute();
  }

  Future<void> _getCurrentLocationAndRoute() async {
    // Get the user's current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get the destination location
    double destLat = double.parse(widget.lat);
    double destLong = double.parse(widget.long);

    // Set markers for the user's current location and destination
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId("origin"),
          position: LatLng(position.latitude, position.longitude)));
      _markers.add(Marker(
          markerId: MarkerId("destination"),
          position: LatLng(destLat, destLong)));
    });

    // Fetch and set the polyline
    await _getPolyline(position, LatLng(destLat, destLong));
  }

  Future<void> _getPolyline(Position position, LatLng destination) async {
    String googleMapsApiKey = "AIzaSyCn3-sHGjJt6uU4kW51NEiUUf__s_fedsI";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${position.latitude},${position.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=$googleMapsApiKey";
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'OK') {
        String encodedPolyline =
            jsonResponse['routes'][0]['overview_polyline']['points'];
        List<LatLng> polylinePoints = _decodePolyline(encodedPolyline);
        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId("route"),
            points: polylinePoints,
            color: Colors.blue,
            width: 5,
          ));
        });
      }
    }
  }

  List<LatLng> _decodePolyline(String encodedPolyline) {
    List<LatLng> decodedPolyline = [];
    List<int> polylineChars = encodedPolyline.codeUnits;

    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polylineChars.length) {
      int shift = 0;
      int result = 0;

      int c;
      do {
        c = polylineChars[index++] - 63;
        result |= (c & 0x1F) << shift;
        shift += 5;
      } while (c >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        c = polylineChars[index++] - 63;
        result |= (c & 0x1F) << shift;
        shift += 5;
      } while (c >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      decodedPolyline.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return decodedPolyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Route Map")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(widget.lat), double.parse(widget.long)),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
