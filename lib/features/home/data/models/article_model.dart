class ArticleModel {
  final int id;
  final String title;
  final String summary;
  final String? imageUrl;
  final String? url;
  final String? createdAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    this.imageUrl,
    this.url,
    this.createdAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      summary: json['summary'] ?? json['description'] ?? '',
      imageUrl: json['imageUrl'],
      url: json['url'],
      createdAt: json['createdAt'] ?? json['date'],
    );
  }
}
