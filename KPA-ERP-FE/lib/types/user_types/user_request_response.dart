class RequestedUserResponse {
  final int id;
  final String userFName;
  final String userMName;
  final String userLName;
  final String userEmail;
  final String userPhone;
  final String userType;
  final bool approved;
  final bool seen;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;
  final String userDepot;
  final Map<String, List<String>> trainDetails;

  RequestedUserResponse({
    required this.id,
    required this.userFName,
    required this.userMName,
    required this.userLName,
    required this.userEmail,
    required this.userPhone,
    required this.userType,
    required this.approved,
    required this.seen,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.userDepot,
    required this.trainDetails,
  });

  factory RequestedUserResponse.fromJson(Map<String, dynamic> json) {
    return RequestedUserResponse(
      id: json['id']  ?? 0,
      userFName: json['first_name'] ?? '',
      userMName: json['middle_name'] ?? '',
      userLName: json['last_name'] ?? '',
      userEmail: json['email'] ?? '',
      userPhone: json['phone_number'] ?? '',
      userType: json['user_type'] ?? '',
      approved: json['approved'] ?? false,
      seen: json['seen'] ?? false,
      createdAt: json['created_at'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      userDepot: json['depo'] ?? '',
      trainDetails: (json['train_details'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userFName': userFName,
      'userMName': userMName,
      'userLName': userLName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'userType': userType,
      'approved': approved,
      'seen': seen,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
      'updatedBy': updatedBy,
      'userDepot': userDepot,
      'train_details': trainDetails.map(
        (key, value) => MapEntry(key, value),
      ),
    };
  }
}