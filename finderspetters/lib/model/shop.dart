class Shop {
  String id;
  String name;
  String address;
  String lat;
  String long;
  String imgUrl;
  String logoUrl;
  String schedule;
  int rating;
  double distance;
  bool isOpenNow;
  List<String> products;
  List<String> productImages;
  List<String> productDescription;
  List<int> productPrice;
  Map<String, List<dynamic>> availableTime;
  Shop(
      {required this.id,
      required this.name,
      required this.address,
      required this.lat,
      required this.long,
      required this.imgUrl,
      required this.logoUrl,
      required this.rating,
      required this.products,
      required this.productImages,
      required this.productDescription,
      required this.productPrice,
      required this.schedule,
      this.distance = 0,
      this.isOpenNow = false,
      required this.availableTime});

  static Shop fromJson(Map<String, dynamic> json) => Shop(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      lat: json['lat'],
      long: json['long'],
      imgUrl: json['imgUrl'] ?? "",
      logoUrl: json['logoUrl'] ?? "",
      rating: json['rating'],
      products: List<String>.from(json['products'] ?? {}),
      productImages: List<String>.from(json['productImages'] ?? {}),
      productDescription: List<String>.from(json['productDescription'] ?? {}),
      productPrice: List<int>.from(json['productPrices'] ?? {}),
      schedule: json['schedule'] ?? "",
      availableTime:
          Map<String, List<dynamic>>.from(json['availableTime'] ?? {}));
}
