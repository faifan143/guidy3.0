import 'dart:convert';

class FollowModel {
  final int shopId;
  final String shopName;
  final int shopPhone;
  final String shopAddress;
  final double latitude;
  final double longitude;
  final double shopRating;
  final List<String> shopPhotos;

  FollowModel({
    required this.shopId,
    required this.shopName,
    required this.shopPhone,
    required this.shopAddress,
    required this.latitude,
    required this.longitude,
    required this.shopRating,
    required this.shopPhotos,
  });

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      shopId: int.parse(json['shop_id'].toString()),
      shopName: json['shop_name'],
      shopPhone: int.parse(json['shop_phone'].toString()),
      shopAddress: json['shop_address'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      shopRating: double.parse(json['shop_rating'].toString()),
      shopPhotos: json['shop_photos'] != null ? List<String>.from(json['shop_photos']) : [],
    );
  }
}
