import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String id;
  String storeId;
  String storeName;
  String storeAddress;
  String email;
  bool hasOrdered;
  Timestamp? orderedDate;
  List<String> products;
  List<String> productImages;
  List<String> productDescription;
  List<int> productPrice;
  List<int> quantity;
  Cart({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.storeAddress,
    required this.email,
    required this.hasOrdered,
    this.orderedDate,
    required this.products,
    required this.productImages,
    required this.productDescription,
    required this.productPrice,
    required this.quantity,
  });

  static Cart fromJson(Map<String, dynamic> json) => Cart(
        id: json['id'],
        storeId: json['storeId'],
        storeName: json['storeName'],
        storeAddress: json['storeAddress'],
        email: json['userEmail'],
        hasOrdered: json['hasOrdered'],
        orderedDate: json['orderedDate'],
        products: List<String>.from(json['products'] ?? []),
        productImages: List<String>.from(json['productImages'] ?? []),
        productDescription:
            List<String>.from(json['productDescriptions'] ?? []),
        productPrice: List<int>.from(json['productPrices'] ?? []),
        quantity: List<int>.from(json['productQuantity'] ?? []),
      );
}
