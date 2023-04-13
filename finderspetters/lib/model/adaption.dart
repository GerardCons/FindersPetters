class Adaption {
  String id;
  String name;
  String contactNumber;
  String address;
  String lat;
  String long;
  String imgUrl;
  String logoUrl;
  String description;
  String schedule;
  int rating;
  double distance;
  bool isOpenNow;
  Map<String, List<dynamic>> availableTime;
  Adaption(
      {required this.id,
      required this.name,
      required this.contactNumber,
      required this.address,
      required this.lat,
      required this.long,
      required this.imgUrl,
      required this.logoUrl,
      required this.rating,
      required this.description,
      required this.schedule,
      this.distance = 0,
      this.isOpenNow = false,
      required this.availableTime});

  static Adaption fromJson(Map<String, dynamic> json) => Adaption(
      id: json['id'],
      name: json['name'],
      contactNumber: json['contactNumber'] ?? "",
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      imgUrl: json['imgUrl'] ?? "",
      description: json['description'] ?? "",
      logoUrl: json['logoUrl'] ?? "",
      rating: json['rating'],
      schedule: json['schedule'] ?? "",
      availableTime:
          Map<String, List<dynamic>>.from(json['availableTime'] ?? {}));
}
