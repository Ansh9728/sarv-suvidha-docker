class VerifyRequest {
  final String value;
  final String otp;
  final String type;

  VerifyRequest({required this.value, required this.otp,required this.type});

  Map<String, dynamic> toJson() {
    if(type=="phone"){
      return {
        'phone': value,
        'otp': otp,
      };
    }
    else{
      return {
        'email': value,
        'otp': otp,
      };
    }
    
  }
}