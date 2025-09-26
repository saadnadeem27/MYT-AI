class PromptModel {
  final String id;
  final String title;
  final String content;
  final String category;
  final String type; // 'text', 'image', 'code'
  final String tone;
  final String style;
  final int complexity;
  final DateTime createdAt;
  final bool isFavorite;
  final int likes;
  final List<String> tags;
  final String authorId;
  final String authorName;

  PromptModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.type,
    required this.tone,
    required this.style,
    required this.complexity,
    required this.createdAt,
    this.isFavorite = false,
    this.likes = 0,
    this.tags = const [],
    required this.authorId,
    required this.authorName,
  });

  PromptModel copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? type,
    String? tone,
    String? style,
    int? complexity,
    DateTime? createdAt,
    bool? isFavorite,
    int? likes,
    List<String>? tags,
    String? authorId,
    String? authorName,
  }) {
    return PromptModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      type: type ?? this.type,
      tone: tone ?? this.tone,
      style: style ?? this.style,
      complexity: complexity ?? this.complexity,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      likes: likes ?? this.likes,
      tags: tags ?? this.tags,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'type': type,
      'tone': tone,
      'style': style,
      'complexity': complexity,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
      'likes': likes,
      'tags': tags,
      'authorId': authorId,
      'authorName': authorName,
    };
  }

  factory PromptModel.fromJson(Map<String, dynamic> json) {
    return PromptModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      type: json['type'],
      tone: json['tone'],
      style: json['style'],
      complexity: json['complexity'],
      createdAt: DateTime.parse(json['createdAt']),
      isFavorite: json['isFavorite'] ?? false,
      likes: json['likes'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      authorId: json['authorId'],
      authorName: json['authorName'],
    );
  }
}
