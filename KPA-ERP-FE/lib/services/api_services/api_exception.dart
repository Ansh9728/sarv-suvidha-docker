class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  ApiException.fromJson(int statusCode, Map<String, dynamic> json)
      : statusCode = statusCode,
        message = json['message'] ?? 'Unknown error occoured';

  @override
  String toString() {
    return message;
  }
}

class DetailedApiException implements Exception {
  final int statusCode;
  final String message;
  final dynamic details;

  DetailedApiException(this.statusCode, this.message, [this.details]);

  DetailedApiException.fromJson(int statusCode, Map<String, dynamic> json)
      : statusCode = statusCode,
        message = json['message'] ?? 'Unknown error occurred',
        details = json['details'];

  @override
  String toString() {
    return 'Error: $message\nDetails: $details';
  }
}