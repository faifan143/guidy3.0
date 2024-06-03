
class OfferModel {
  final String offerId;
  final String offerName;
  final String description;
  final DateTime expirationDate;
  final DateTime startDate;
  final List<String> offerPhotos;

  OfferModel({
    required this.offerId,
    required this.offerName,
    required this.description,
    required this.expirationDate,
    required this.startDate,
    required this.offerPhotos,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      offerId: json['offer_id'].toString(),
      offerName: json['offer_name'],
      description: json['description'],
      expirationDate: DateTime.parse(json['expiration_date']),
      startDate: DateTime.parse(json['start_date']),
      offerPhotos: json['offer_photos'] != null
          ? List<String>.from(json['offer_photos'])
          : [],
    );
  }

  int getDaysDifference() {
    // Get the current date
    DateTime currentDate = DateTime.now();

    // Calculate the difference in days
    Duration difference = expirationDate.difference(currentDate);

    // Return the difference in days
    return difference.inDays;
  }

}