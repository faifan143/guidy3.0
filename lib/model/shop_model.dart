class ShopModel {
  late String shop_id;
  late String shop_name;
  late String shop_phone;
  late String shop_address;
  late String latitude;
  late String longitude;
  late String shop_rating;
  late List<String> shop_photos;
  ShopModel(
      {required this.shop_id,
        required this.shop_name,
        required this.shop_phone,
        required this.shop_address,
        required this.shop_rating,
        required this.shop_photos,
        required this.latitude,
        required this.longitude});
  ShopModel.fromJson(Map<String, dynamic> json)
      : shop_id = json['shop_id'].toString(),
        shop_name = json['shop_name'].toString(),
        shop_phone = json['shop_phone'].toString(),
        shop_address = json['shop_address'].toString(),
        shop_rating = json['shop_rating'].toString(),
        latitude = json['latitude'].toString(),
        longitude = json['longitude'].toString(),
        shop_photos = List<String>.from(json['shop_photos'] ?? []);
  Map<String, dynamic> toJson() {
    return {
      'shop_id': shop_id,
      'shop_name': shop_name,
      'shop_phone': shop_phone,
      'shop_address': shop_address,
      'shop_rating': shop_rating,
      'latitude': latitude,
      'longitude': longitude,
      'shop_photos': shop_photos,
    };
  }
}