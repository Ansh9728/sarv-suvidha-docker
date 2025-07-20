class UpdateRequestResponse {
  final List<UpdateRequest> updateRequests;
  final int totalCount;
  final String message;
  final UserResponse currentUser;

  UpdateRequestResponse({
    required this.updateRequests,
    required this.totalCount,
    required this.message,
    required this.currentUser,
  });

  factory UpdateRequestResponse.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse boolean values
    bool _parseBooleanField(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) {
        if (value.isEmpty) return false;
        return value.toLowerCase() == 'true';
      }
      return false;
    }

    return UpdateRequestResponse(
      updateRequests: json['update_requests'] != null
          ? List<UpdateRequest>.from(
              json['update_requests'].map((x) => UpdateRequest.fromJson(x)))
          : [],
      currentUser: json['user'] != null
          ? UserResponse.fromJson(json['current_user'])
          : UserResponse.empty(), // Create an empty constructor

      totalCount: json['total_count'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

// Updated UpdateRequest model with safe boolean parsing
class UpdateRequest {
  final int id;
  final UserWithDetails user;
  final String createdAt;
  final String updatedBy;

  UpdateRequest({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.updatedBy,
  });

  factory UpdateRequest.fromJson(Map<String, dynamic> json) {
    return UpdateRequest(
      id: json['id'],
      user: UserWithDetails.fromJson(json['user']),
      createdAt: json['created_at'],
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'created_at': createdAt,
      'updated_by': updatedBy,
    };
  }
}

class UserWithDetails {
  final int id;
  final String username;
  final String email;
  final String phone;
  final UserDetailsData currentDetails;
  final UserDetailsData requestedChanges;

  UserWithDetails({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.currentDetails,
    required this.requestedChanges,
  });

  factory UserWithDetails.fromJson(Map<String, dynamic> json) {
    return UserWithDetails(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      currentDetails: UserDetailsData.fromJson(json['current_details']),
      requestedChanges: UserDetailsData.fromJson(json['requested_changes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'current_details': currentDetails.toJson(),
      'requested_changes': requestedChanges.toJson(),
    };
  }
}

class UserDetailsData {
  final String? fName;
  final String? mName;
  final String? lName;
  final String? email;
  final String? phone;
  final String? whatsappNumber;
  final String? userType;
  final String? zone;
  final String? depo;
  final String? empNumber;
  final String? division;
  final String user_status;

  UserDetailsData({
    this.fName,
    this.mName,
    this.lName,
    this.email,
    this.phone,
    this.whatsappNumber,
    this.userType,
    this.zone,
    this.depo,
    this.empNumber,
    this.division,
    required this.user_status,
  });

  factory UserDetailsData.fromJson(Map<String, dynamic> json) {
    return UserDetailsData(
        fName: json['f_name'],
        mName: json['m_name'],
        lName: json['l_name'],
        email: json['email'],
        phone: json['phone'],
        whatsappNumber: json['whatsapp_number'],
        userType: json['user_type'],
        zone: json['zone'],
        depo: json['depo'],
        empNumber:
            json['emp_number']?.toString(), // Convert to string if not null
        division: json['division']?.toString(),
        user_status: json['user_status']
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'f_name': fName,
      'm_name': mName,
      'l_name': lName,
      'email': email,
      'phone': phone,
      'whatsapp_number': whatsappNumber,
      'user_type': userType,
      'zone': zone,
      'depo': depo,
      'emp_number': empNumber,
      'division': division,
      'user_status': user_status
    };
  }
}

// Keep your existing UserResponse class
class UserResponse {
  final int id;
  final String username;
  final String email;
  final String userTypeName;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String phone;
  final String whatsappNumber;
  final String createdAt;
  final String? empNumber;
  final String user_status;

  UserResponse(
      {required this.id,
      required this.username,
      required this.email,
      required this.userTypeName,
      required this.firstName,
      this.middleName,
      required this.lastName,
      required this.phone,
      required this.whatsappNumber,
      required this.createdAt,
      this.empNumber,
      required this.user_status});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        id: json['id'] ?? 0,
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        userTypeName: json['user_type_name'] ?? '',
        firstName: json['f_name'] ?? '',
        middleName: json['m_name'],
        lastName: json['l_name'] ?? '',
        phone: json['phone'] ?? '',
        whatsappNumber: json['whatsapp_number'] ?? '',
        createdAt: json['created_at'] ?? '',
        empNumber: json['emp_number']?.toString(),
        user_status: json['user_status'] 

        /// Convert to string if not null
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'user_type_name': userTypeName,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'phone': phone,
      'whatsapp_number': whatsappNumber,
      'created_at': createdAt,
      'emp_number': empNumber,
      'user_status': user_status
    };
  }

  factory UserResponse.empty() {
    return UserResponse(
      id: 0,
      username: '',
      email: '',
      userTypeName: '',
      firstName: '',
      middleName: '',
      lastName: '',
      phone: '',
      whatsappNumber: '',
      createdAt: '',
      empNumber: '',
      user_status: 'disabled',
    );
  }
}
