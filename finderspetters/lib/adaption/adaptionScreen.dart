import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/adaption/adaptionStoreScreen.dart';
import 'package:finderspetters/model/adaption.dart';
import 'package:finderspetters/screens/grooming/groomingStoreScreen.dart';
import 'package:finderspetters/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../model/grooming.dart';

class AdaptionScreenWidget extends StatefulWidget {
  const AdaptionScreenWidget({super.key});

  @override
  State<AdaptionScreenWidget> createState() => _AdaptionScreenWidgetState();
}

class _AdaptionScreenWidgetState extends State<AdaptionScreenWidget> {
  String address = '';
  String query = '';
  final List<Adaption> _places = [];
  List<Adaption> _searchPlaces = [];

  void search(String value) {
    _searchPlaces.clear;
    List<Adaption> _searchPlacesQuery = [];

    for (int i = 0; i < _places.length; i++) {
      if (_places[i].name.toLowerCase().contains(value.toLowerCase())) {
        _searchPlacesQuery.add(_places[i]);
      }
    }
    _searchPlaces = _searchPlacesQuery;
    setState(() {
      _calculateDistances();

      print(_searchPlaces.length);
    });
  }

  Future<void> _calculateDistances() async {
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

    Position? _currentUserPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    for (final place in _searchPlaces) {
      double doubleAreaLat = double.parse(place.lat);
      double doubleAreaLong = double.parse(place.long);
      double distanceInMeter = Geolocator.distanceBetween(
          _currentUserPosition.latitude,
          _currentUserPosition.longitude,
          doubleAreaLat,
          doubleAreaLong);
      double roundedDistance = distanceInMeter.roundToDouble();
      double distanceInKM = roundedDistance / 1000;
      setState(() {
        place.distance = distanceInKM;
        place.isOpenNow = _checkIsOpenNow(place.availableTime);
      });
    }
  }

  bool _checkIsOpenNow(Map<String, dynamic> schedule) {
    print("run check time function");
    final weekday = DateFormat('EEE').format(DateTime.now());
    final currentTime = TimeOfDay.now();
    print(weekday.toUpperCase());
    if (schedule.containsKey(weekday.toUpperCase())) {
      final List<String> times =
          List<String>.from(schedule[weekday.toUpperCase()]);
      print(times);
      final startTime = TimeOfDay(
        hour: int.parse(times.first.split(':')[0]),
        minute: int.parse(times.first.split(':')[1]),
      );
      final endTime = TimeOfDay(
        hour: int.parse(times.last.split(':')[0]),
        minute: int.parse(times.last.split(':')[1]),
      );

      print(
          "Opens at (${startTime.hour}:${startTime.minute}) and Closes at (${endTime.hour}:${endTime.minute})");
      print("Current time is ${currentTime.hour}:${currentTime.minute}");

      if (currentTime.hour >= startTime.hour &&
          currentTime.hour <= endTime.hour) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Adaption Directory')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        final adaptionPlace = Adaption.fromJson(doc.data());
        _places.add(adaptionPlace);
        setState(() {
          _searchPlaces = _places;
        });
      });

      _calculateDistances();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(249, 235, 227, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(249, 235, 227, 1),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => UserPage()));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: Text(
            "Adaption Centers",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 1,
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                    onSubmitted: search,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Enter your search query',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => search(query),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _searchPlaces.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (_searchPlaces[index].isOpenNow == true) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => PreviewAdaptionScreen(
                                        storeAddress:
                                            _searchPlaces[index].address,
                                        storeImage: _searchPlaces[index].imgUrl,
                                        storeName: _searchPlaces[index].name,
                                        storeDescription:
                                            _searchPlaces[index].description,
                                        storeLat: _searchPlaces[index].lat,
                                        storeLong: _searchPlaces[index].long,
                                      )));
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              width: 160,
                              height: 130,
                              margin: EdgeInsets.only(right: 16.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          _searchPlaces[index].logoUrl),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Text(_searchPlaces[index].name,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4.0),
                              (_searchPlaces[index].isOpenNow == true)
                                  ? Row(
                                      children: [
                                        Text(
                                            "${_searchPlaces[index].distance} km away"),
                                        SizedBox(width: 5),
                                        Text(
                                          "(Open)",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                            "${_searchPlaces[index].distance} km away"),
                                        SizedBox(width: 5),
                                        Text(
                                          "(Close)",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 4.0),
                              Text(_searchPlaces[index].address),
                              SizedBox(height: 4),
                              RatingBar.builder(
                                initialRating:
                                    _searchPlaces[index].rating.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20.0,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                ignoreGestures: true,
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
