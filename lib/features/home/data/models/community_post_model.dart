class CommunityPostModel {
  final int id;
  final String content;
  final String authorName;
  final String createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;

  CommunityPostModel({
    required this.id,
    required this.content,
    required this.authorName,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
  });

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? json['title'] ?? '',
      authorName: json['authorName'] ?? json['userName'] ?? 'Unknown',
      createdAt: json['createdAt'] ?? json['date'] ?? '',
      likesCount: json['likesCount'] ?? json['likes'] ?? 0,
      commentsCount: json['commentsCount'] ?? json['comments'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }

  CommunityPostModel copyWith({
    int? id,
    String? content,
    String? authorName,
    String? createdAt,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
  }) {
    return CommunityPostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
