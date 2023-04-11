class Grooming {
  String id;
  String name;
  String contactNumber;
  String address;
  String lat;
  String long;
  String imgUrl;
  String logoUrl;
  String schedule;
  int rating;
  double distance;
  bool isOpenNow;
  List<String> services;
  Map<String, List<dynamic>> availableTime;
  Grooming(
      {required this.id,
      required this.name,
      required this.contactNumber,
      required this.address,
      required this.lat,
      required this.long,
      required this.imgUrl,
      required this.logoUrl,
      required this.rating,
      required this.services,
      required this.schedule,
      this.distance = 0,
      this.isOpenNow = false,
      required this.availableTime});

  static Grooming fromJson(Map<String, dynamic> json) => Grooming(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contactNumber'] ?? "",
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      imgUrl: json['imgUrl'] ?? "",
      logoUrl: json['logoUrl'] ?? "",
      rating: json['rating'],
      services: List<String>.from(json['services'] ?? {}),
      schedule: json['schedule'] ?? "",
      availableTime:
          Map<String, List<dynamic>>.from(json['availableTime'] ?? {}));
}
