class SignupRequest {
  final String fName;
  final String lName;
  final String mName;
  final String email;
  final String phone;
  final String whatsappNumber;
  final String secondaryPhoneNumber;
  final String password;
  final String rePassword;
  final String userType;
  final String division;
  final String trains;
  final String coaches;
  final String depo;
  final String empNumber;
  final String zone;
  final String? createdBy;
  final String? createdByUserRole;

  SignupRequest({
    required this.fName,
    required this.lName,
    required this.mName,
    required this.email,
    required this.phone,
    required this.whatsappNumber,
    required this.secondaryPhoneNumber,
    required this.password,
    required this.rePassword,
    required this.userType,
    required this.division,
    required this.trains,
    required this.coaches,
    required this.depo,
    required this.empNumber,
    required this.zone,
    this.createdBy, 
    this.createdByUserRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'f_name': fName,
      'm_name': mName,
      'l_name': lName,
      'email': email,
      'phone': phone,
      'whatsapp_number': whatsappNumber,
      'secondary_phone': secondaryPhoneNumber,
      'password': password,
      're_password': rePassword,
      'user_type': userType,
      'division': division,
      'trains': trains,
      'coaches': coaches,
      'depo': depo,
      'emp_number': empNumber,
      'zone': zone,
      'created_by': createdBy ?? "admin",  
      'created_by_user_role': createdByUserRole ?? "railway admin",   
    };
  }
}
