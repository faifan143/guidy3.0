class UserModel {
  late String email;
  late String username;
  late String image;
  late String address;
  late String phone;
  late String latitude;
  late String longitude;

  UserModel(
      {required this.email,
      required this.address,
      required this.phone,
      required this.image,
      required this.username,
      required this.latitude,
      required this.longitude});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['cust_name'].toString();
    email = json['cust_email'].toString();
    phone = json['cust_phone'].toString();
    image = json['cust_picture'].toString();
    address = json['cust_address'].toString();
    latitude = json['cust_latitude'].toString();
    longitude = json['cust_longitude'].toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'cust_name': username,
      'cust_phone': phone,
      'cust_email': email,
      'cust_address': address,
      'cust_image': image,
      'cust_latitude': latitude,
      'cust_longitude': longitude,
    };
  }

}
