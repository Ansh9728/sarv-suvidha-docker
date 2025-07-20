class LoginResponse {
  final String token;
  final String refreshToken;
  final String mobileNumber;
  final String whatsappNumber;
  final String userType;
  final String userName;
  final int stationCode;
  final String stationName;
  final String stationCategory;

  LoginResponse({
    required this.token,
    required this.refreshToken,
    required this.mobileNumber,
    required this.whatsappNumber,
    required this.userType,
    required this.userName,
    required this.stationCode,
    required this.stationName,
    required this.stationCategory,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      mobileNumber: json['phone_number'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
      userType: json['user_type'] ?? '',
      userName: json['username'] ?? '',
      stationCode: json['station'] ?? 0,
      stationName: json['station_name'] ?? '',
      stationCategory: json['station_category'] ?? '',
    );
  }
  factory LoginResponse.forState(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      whatsappNumber: json['whatsappNumber'] ?? '',
      userType: json['userType'] ?? '',
      userName: json['userName'] ?? '',
      stationCode: json['stationCode'] ?? 0,
      stationName: json['stationName'] ?? '',
      stationCategory: json['stationCategory'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'mobileNumber': mobileNumber,
      'whatsappNumber': whatsappNumber,
      'userType': userType,
      'userName': userName,
      'stationCode': stationCode,
      'stationName': stationName,
      'stationCategory': stationCategory,
    };
  }
}
