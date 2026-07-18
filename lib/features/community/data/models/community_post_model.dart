class CommunityPostModel {
  final int id;
  final String content;
  final String authorName;
  final String? authorId;
  final String? authorImage;
  final String createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final List<CommentModel> comments;

  CommunityPostModel({
    required this.id,
    required this.content,
    required this.authorName,
    this.authorId,
    this.authorImage,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    this.isLiked = false,
    this.comments = const [],
  });
   
  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    var commentsList = <CommentModel>[];
    if (json['comments'] != null) {
      commentsList = (json['comments'] as List)
          .map((i) => CommentModel.fromJson(i))
          .toList();
    }

    return CommunityPostModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? json['title'] ?? '',
      authorName: json['authorName'] ?? json['userName'] ?? 'Unknown',
      authorId: json['authorId']?.toString() ?? json['userId']?.toString(),
      authorImage: json['authorImage'] ?? json['userImage'],
      createdAt: json['createdAt'] ?? json['date'] ?? '',
      likesCount: json['likesCount'] ?? json['likes'] ?? 0,
      commentsCount: json['commentsCount'] ?? json['commentsCount'] ?? commentsList.length,
      isLiked: json['isLiked'] ?? false,
      comments: commentsList,
    );
  }
}

class CommentModel {
  final int id;
  final String content;
  final String userName;
  final String? userId;
  final String? userImage;
  final String createdAt;

  CommentModel({
    required this.id,
    required this.content,
    required this.userName,
    this.userId,
    this.userImage,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      userName: json['userName'] ?? 'Unknown',
      userId: json['userId']?.toString(),
      userImage: json['userImage'],
      createdAt: json['createdAt'] ?? '',
    );
  }
}
