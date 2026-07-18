class ArticleModel {
  final String title;
  final String description;
  final String imageUrl;
  final String url;
  final String date;

  ArticleModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    required this.date,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      url: json['url'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'url': url,
      'date': date,
    };
  }
}
