class Profile {
  String email;
  String fullName;
  String id;
  String mobileNumber;
  String username;
  String? imageUrl;
  String? address;
  double? lat;
  double? long;

  Profile({
    required this.email,
    required this.fullName,
    required this.id,
    required this.mobileNumber,
    required this.username,
    this.imageUrl,
    this.address,
    this.lat,
    this.long,
  });

  static Profile fromJson(Map<String, dynamic> json) => Profile(
        email: json['email'],
        fullName: json['fullName'],
        mobileNumber: json['mobileNumber'] ?? "",
        id: json['id'],
        username: json['username'],
        imageUrl: json['imageUrl'] ?? "",
        address: json['address'] ?? "",
        lat: json['lat'] ?? 0.0,
        long: json['long'] ?? 0.0,
      );
}
