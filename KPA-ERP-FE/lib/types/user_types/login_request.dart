class LoginRequest {
  final String mobileNumber;
  final String password;

  LoginRequest({required this.mobileNumber, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'phone': mobileNumber,
      'password': password,
    };
  }
}