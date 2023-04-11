class Clinic {
  String id;
  String name;
  String contactNumber;
  String address;
  String lat;
  String long;
  String imgUrl;
  String logoUrl;
  String schedule;
  String veterinarian;
  int rating;
  double distance;
  bool isOpenNow;
  List<String> services;
  Map<String, List<dynamic>> availableTime;
  Clinic(
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
      required this.veterinarian,
      this.distance = 0,
      this.isOpenNow = false,
      required this.availableTime});

  static Clinic fromJson(Map<String, dynamic> json) => Clinic(
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
      veterinarian: json['veterinarian'] ?? "",
      availableTime:
          Map<String, List<dynamic>>.from(json['availableTime'] ?? {}));
}
