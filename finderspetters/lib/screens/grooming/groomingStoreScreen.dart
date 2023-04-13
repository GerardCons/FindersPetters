import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finderspetters/components/utils.dart';
import 'package:finderspetters/model/grooming.dart';
import 'package:finderspetters/screens/grooming/googleMapLocation.dart';
import 'package:finderspetters/screens/grooming/groomingReviewAppointment.dart';
import 'package:finderspetters/screens/grooming/groomingScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class GroomingStoreScreen extends StatefulWidget {
  final String storeId;
  const GroomingStoreScreen({Key? key, required this.storeId});

  @override
  State<GroomingStoreScreen> createState() => _GroomingStoreScreenState();
}

class _GroomingStoreScreenState extends State<GroomingStoreScreen> {
  final List<Grooming> _places = [];
  DateTime _selectedDay = DateTime.now();
  List<String> times = [];
  List<String> services = [];
  List<String> petKind = ["Dog", "Cat", "Others"];
  bool isLoading = false;
  bool isSent = false;
  String selectedTime = "";
  String selectedKind = "";
  String? storeName;
  String? storeId;
  String? storeAddress;
  String weekday = "";
  List<String> selectedServices = [];

  void _handleTimeSelected(String time) {
    setState(() {
      selectedTime = time;
    });
  }

  void _handleTPetKindSelected(String kind) {
    setState(() {
      selectedKind = kind;
    });
  }

  void _handleServiceSelected(String service) {
    setState(() {
      if (selectedServices.contains(service)) {
        selectedServices.remove(service);
      } else {
        selectedServices.add(service);
      }
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
    for (final place in _places) {
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
        services = place.services;
        storeAddress = place.address;
        storeName = place.name;
        storeId = place.id;
        place.isOpenNow = _checkIsOpenNow(place.availableTime);
        isLoading = true;
      });
      print(place.services);
      print(_places[0].distance);
    }
  }

  bool _checkIsOpenNow(Map<String, dynamic> schedule) {
    print("run check time function");

    weekday = DateFormat('EEE').format(DateTime.now());
    final currentTime = TimeOfDay.now();
    print(weekday.toUpperCase());
    if (schedule.containsKey(weekday.toUpperCase())) {
      times = List<String>.from(schedule[weekday.toUpperCase()]);
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
    print(widget.storeId.trim());
    FirebaseFirestore.instance
        .collection('Grooming Directory')
        .doc(widget.storeId.trim())
        .get()
        .then((doc) {
      if (doc.exists) {
        final data = doc.data();
        final groomingPlace = Grooming.fromJson(data!);
        _places.add(groomingPlace);
        _calculateDistances();
      } else {
        print("No data fetched");
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final DateTime currentDate = DateTime.now();
    final currentMonth = DateFormat.MMMM().format(currentDate);
    final DateTime lastDayOfMonth =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    return Scaffold(
      backgroundColor: Color.fromRGBO(249, 235, 227, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(249, 235, 227, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => GroomingScreenWidget()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          "Grooming",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
      ),
      body: (isLoading == false)
          ? CircularProgressIndicator()
          : StreamBuilder<List<Grooming>>(
              stream: readStore(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something Went Wrong ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final store = snapshot.data!;
                  return Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.28,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(store.first.imgUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 40.0,
                              left: 16.0,
                              child: Text(
                                store.first.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Positioned(
                              bottom: 20.0,
                              left: 14.0,
                              child: Text(
                                "${_places[0].distance} km away",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            (_places[0].isOpenNow == true)
                                ? Positioned(
                                    bottom: 20.0,
                                    left: 110.0,
                                    child: Text(
                                      "(Open)",
                                      style: TextStyle(color: Colors.green),
                                    ))
                                : Positioned(
                                    bottom: 20.0,
                                    left: 110.0,
                                    child: Text(
                                      "(Close)",
                                      style: TextStyle(color: Colors.red),
                                    )),
                            Positioned(
                              bottom: 5.0,
                              left: 14.0,
                              child: Row(
                                children: [
                                  Text(
                                    "Star Rating:",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  SizedBox(width: 2),
                                  RatingBar.builder(
                                    initialRating: _places[0].rating.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 11.0,
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
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 5.0,
                              right: 10.0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RouteMapScreen(
                                        lat: _places[0].lat,
                                        long: _places[0].long,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.red),
                                    SizedBox(width: 2),
                                    Text(
                                      "Get directions",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.61,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                            color: Color.fromRGBO(249, 235, 227, 1),
                            // add a border for testing
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Divider(
                                  color: Colors.grey,
                                  thickness: 5.0,
                                  indent:
                                      MediaQuery.of(context).size.width * 0.42,
                                  endIndent:
                                      MediaQuery.of(context).size.width * 0.42,
                                ),
                                SizedBox(height: 15),
                                Center(
                                    child: Text(
                                  "Appointment",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                                SizedBox(height: 15),
                                Center(
                                    child: Text(
                                  currentMonth,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                )),
                                SizedBox(height: 15),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SizedBox(
                                    height: 60,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: lastDayOfMonth.day,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final int day = index + 1;
                                        final DateTime date = DateTime(
                                            currentDate.year,
                                            currentDate.month,
                                            day);
                                        final bool isToday =
                                            _selectedDay.day == day &&
                                                _selectedDay.month ==
                                                    currentDate.month &&
                                                _selectedDay.year ==
                                                    currentDate.year;
                                        return GestureDetector(
                                          onTap: () {
                                            _selectedDay = DateTime(
                                                currentDate.year,
                                                currentDate.month,
                                                index + 1);

                                            setState(() {
                                              weekday = DateFormat('EEE')
                                                  .format(_selectedDay);
                                            });
                                          },
                                          child: Container(
                                            height: 60,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              color: isToday
                                                  ? Colors.green
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat("d").format(date),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: isToday
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  DateFormat("E").format(date),
                                                  style: TextStyle(
                                                    color: isToday
                                                        ? Colors.white
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Center(
                                    child: Text(
                                  "Available Times",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 90,
                                  child: GridView.builder(
                                    shrinkWrap: false,
                                    itemCount: times.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 3,
                                    ),
                                    itemBuilder: (context, index) {
                                      final time = times[index];
                                      final isSelected = selectedTime == time;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: MaterialButton(
                                          onPressed: () =>
                                              _handleTimeSelected(time),
                                          color: isSelected
                                              ? Colors.green
                                              : Color.fromRGBO(
                                                  249, 235, 227, 1),
                                          textColor: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(time),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 15),
                                Center(
                                    child: Text(
                                  "Kind of Pet",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                                SizedBox(height: 10),
                                GridView.count(
                                    shrinkWrap:
                                        true, // Add this line to avoid the height conflict
                                    physics:
                                        NeverScrollableScrollPhysics(), // Add this line to avoid scrolling conflicts
                                    crossAxisCount: 3,
                                    childAspectRatio: 3,
                                    children: petKind.map((kind) {
                                      final isSelected = selectedKind == kind;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: MaterialButton(
                                          onPressed: () =>
                                              _handleTPetKindSelected(kind),
                                          color: isSelected
                                              ? Colors.green
                                              : Color.fromRGBO(
                                                  249, 235, 227, 1),
                                          textColor: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(kind),
                                        ),
                                      );
                                    }).toList()),
                                SizedBox(height: 15),
                                Center(
                                    child: Text(
                                  "Services",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                                SizedBox(height: 10),
                                GridView.count(
                                    shrinkWrap:
                                        true, // Add this line to avoid the height conflict
                                    physics:
                                        NeverScrollableScrollPhysics(), // Add this line to avoid scrolling conflicts
                                    crossAxisCount: 2,
                                    childAspectRatio: 3,
                                    children: services.map((service) {
                                      final isSelected =
                                          selectedServices.contains(service);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: MaterialButton(
                                          onPressed: () =>
                                              _handleServiceSelected(service),
                                          color: isSelected
                                              ? Colors.green
                                              : Color.fromRGBO(
                                                  249, 235, 227, 1),
                                          textColor: isSelected
                                              ? Colors.white
                                              : Colors.black,
                                          shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(service),
                                        ),
                                      );
                                    }).toList()),
                                SizedBox(height: 20),
                                loginButton(size),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
    );
  }

  Widget dayCell(DateTime day, bool isToday) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey[300]!),
          color: isToday ? Colors.green : null,
        ),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              DateFormat('EEE').format(day),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isToday ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              day.day.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isToday ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeList(DateTime day) {
    final times = getTimeValuesForDay(day);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: times.length,
      itemBuilder: (context, index) {
        final time = times[index];
        return ListTile(
          title: Text(time),
        );
      },
    );
  }

  InkWell loginButton(Size size) {
    return InkWell(
      onTap: (() {
        if (selectedTime.isEmpty ||
            selectedKind.isEmpty ||
            selectedServices.isEmpty) {
          Utils.errorSnackBar(Icons.error,
              "Please input all requirements before reserving an appointment");
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => groomingReviewAppointment(
                    selectedTime: selectedTime!,
                    clinicAddress: storeAddress!,
                    clinicName: storeName!,
                    clinicId: storeId!,
                    petkind: selectedKind!,
                    services: selectedServices,
                    selectedDate: _selectedDay,
                  )));
        }
      }),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromRGBO(255, 160, 55, 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: (isSent == true)
            ? const CircularProgressIndicator()
            : const Text(
                "Reserve",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  List<String> getTimeValuesForDay(DateTime day) {
    final schedule = _places[0].availableTime;
    final weekday = DateFormat('EEEE').format(day);
    final times =
        List<String>.from(schedule[int.parse(weekday)] as Iterable<dynamic>);
    return times;
  }

  Stream<List<Grooming>> readStore() {
    return FirebaseFirestore.instance
        .collection('Grooming Directory')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((QueryDocumentSnapshot<Object?> element) =>
                element['id'].toString().contains(widget.storeId))
            .map((doc) => Grooming.fromJson(doc.data()))
            .toList());
  }
}
