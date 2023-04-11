class Profile {
  String email;
  String fullName;
  String id;
  String mobileNumber;
  String username;
  String? imageUrl;
  String? address;
  String? lat;
  String? long;
  Profile({
    required this.email,
    required this.fullName,
    required this.id,
    required this.mobileNumber,
    required this.username,
    required this.imageUrl,
    required this.address,
    required this.lat,
    required this.long,
  });

  static Profile fromJson(Map<String, dynamic> json) => Profile(
        email: json['email'],
        fullName: json['fullName'],
        mobileNumber: json['mobileNumber'] ?? "",
        id: json['id'],
        username: json['username'],
        imageUrl: json['imageUrl'],
        address: json['address'],
        lat: json['lat'],
        long: json['long'],
      );
}
