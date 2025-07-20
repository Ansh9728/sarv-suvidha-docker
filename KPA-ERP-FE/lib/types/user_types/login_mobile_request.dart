class LoginMobileRequest {
  final String mobileNumber;
  final String otp;

  LoginMobileRequest({required this.mobileNumber, required this.otp});

  Map<String, dynamic> toJson() {
    return {
      'login_code':otp ,
      'phone': mobileNumber,
    };
  }
}