import 'dart:convert';

class CommunityPost {
  final String id;
  final String author;
  final String title;
  final String content;
  final DateTime createdAt;
  final int likes;
  final bool likedByMe;

  CommunityPost({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.likedByMe = false,
  });

  CommunityPost copyWith({
    String? id,
    String? author,
    String? title,
    String? content,
    DateTime? createdAt,
    int? likes,
    bool? likedByMe,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'author': author,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'likes': likes,
        'likedByMe': likedByMe,
      };

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as String,
      author: json['author'] as String? ?? 'Anonymous',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      likes: json['likes'] as int? ?? 0,
      likedByMe: json['likedByMe'] as bool? ?? false,
    );
  }

  static String encodeList(List<CommunityPost> posts) =>
      jsonEncode(posts.map((e) => e.toJson()).toList());

  static List<CommunityPost> decodeList(String source) {
    final data = jsonDecode(source) as List<dynamic>;
    return data
        .map((e) => CommunityPost.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
