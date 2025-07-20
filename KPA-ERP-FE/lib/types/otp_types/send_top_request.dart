class SendOtp {
  final String value;
  final String type;

  SendOtp({required this.value, required this.type});
  

  Map<String, dynamic> toJson() {
    if(type=='phone'){
      return {
        'phone': value,
      };
    }
    else if(type=='phone_number'){
      return {
        'phone_number': value,
      };
    } else if(type=='forgot_password_otp'){
      return {
        'email': value,
      };
    } else if(type=='deactivate_account'){
      return {
        'phone_number': value,
      };
    }
    else{
      return {
        'email': value,
      };
    }
    
  }
}