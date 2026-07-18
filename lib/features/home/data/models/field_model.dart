class FieldModel {
  final int id;
  final int userId;
  final String fieldName;
  final double acres;
  final String status;
  final String quality;
  final String government;
  final String city;

  FieldModel({
    required this.id,
    required this.userId,
    required this.fieldName,
    required this.acres,
    required this.status,
    required this.quality,
    required this.government,
    required this.city,
  });

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      fieldName: json['field_Name'] ?? '',
      acres: (json['acres'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      quality: json['quality'] ?? '',
      government: json['government'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'field_Name': fieldName,
      'acres': acres,
      'status': status,
      'quality': quality,
      'government': government,
      'city': city,
    };
  }
}
