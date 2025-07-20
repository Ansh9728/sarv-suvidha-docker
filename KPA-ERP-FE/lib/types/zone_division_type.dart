class ZoneDivision {
  final String name;
  final String code;

  ZoneDivision({required this.name, required this.code});

  // Factory method to create Zone from JSON
  factory ZoneDivision.fromJson(Map<String, dynamic> json) {
    return ZoneDivision(
      name: json['name'],
      code: json['code'],
    );
  }
}
