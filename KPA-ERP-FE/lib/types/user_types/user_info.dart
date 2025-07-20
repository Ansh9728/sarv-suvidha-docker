class UserInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String secondaryPhone;

  UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.secondaryPhone,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    String username = json['username'] ?? '';
    String secondaryPhone = '';
    
    // Extract secondary phone from username (format: name_phone_secondary_phone)
    if (username.contains('_')) {
      List<String> parts = username.split('_');
      if (parts.length >= 3) {
        secondaryPhone = parts[2];
      }
    }

    return UserInfo(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      username: username,
      secondaryPhone: secondaryPhone,
    );
  }
}

