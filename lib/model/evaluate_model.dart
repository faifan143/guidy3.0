class EvaluateModel {
  final String evaluationId;
  final String custEmail;
  final String shopId;
  final String pricesFeedback;
  final String productsQualityFeedback;
  final String serviceQualityFeedback;
  final double overallRating;
  final double priceRating;

  EvaluateModel( {
    required this.evaluationId,
    required this.custEmail,
    required this.shopId,
    required this.pricesFeedback,
    required this.productsQualityFeedback,
    required this.serviceQualityFeedback,
    required this.overallRating,
    required this.priceRating,
  });

  factory EvaluateModel.fromJson(Map<String, dynamic> json) {
    return EvaluateModel(
      evaluationId: json['evaluation_id'].toString() ?? '',
      custEmail: json['cust_email'] ?? '',
      shopId: json['shop_id'].toString() ?? '',
      pricesFeedback: json['prices_feedback'] ??'',
      productsQualityFeedback: json['products_quality_feedback'] ??'',
      serviceQualityFeedback: json['service_quality_feedback'] ??'',
      overallRating: double.parse(json['overall_rating'] ?? 0.0),
      priceRating: double.parse(json['price_rating'] ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'evaluation_id': evaluationId,
      'cust_email': custEmail,
      'shop_id': shopId,
      'prices_feedback': pricesFeedback,
      'products_quality_feedback': productsQualityFeedback,
      'service_quality_feedback': serviceQualityFeedback,
      'overall_rating': overallRating,
      'price_rating': priceRating,
    };
  }
}
