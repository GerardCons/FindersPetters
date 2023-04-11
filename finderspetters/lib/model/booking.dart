import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String id;
  String storeId;
  String storeName;
  String storeAddress;
  String email;
  Timestamp? bookingDate;
  Timestamp appointmentDate;
  String time;
  String petKind;
  List<String> services;
  Booking({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.storeAddress,
    required this.email,
    required this.petKind,
    this.bookingDate,
    required this.appointmentDate,
    required this.time,
    required this.services,
  });

  static Booking fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        storeId: json['storeId'],
        storeName: json['storeName'],
        storeAddress: json['storeAddress'],
        email: json['userEmail'],
        bookingDate: json['bookingDate'],
        petKind: json['petKind'],
        appointmentDate: json['appointmentDate'],
        time: json['time'],
        services: List<String>.from(json['services'] ?? []),
      );
}
