class CropModel {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;

  CropModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  factory CropModel.fromJson(Map<String, dynamic> json) {
    return CropModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['cropName'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
