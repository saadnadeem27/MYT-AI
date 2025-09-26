class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final List<String> favoriteCategories;
  final List<String> favoritePrompts;
  final List<String> promptHistory;
  final DateTime joinedAt;
  final bool isPremium;
  final int totalPromptsGenerated;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.favoriteCategories = const [],
    this.favoritePrompts = const [],
    this.promptHistory = const [],
    required this.joinedAt,
    this.isPremium = false,
    this.totalPromptsGenerated = 0,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    List<String>? favoriteCategories,
    List<String>? favoritePrompts,
    List<String>? promptHistory,
    DateTime? joinedAt,
    bool? isPremium,
    int? totalPromptsGenerated,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      favoritePrompts: favoritePrompts ?? this.favoritePrompts,
      promptHistory: promptHistory ?? this.promptHistory,
      joinedAt: joinedAt ?? this.joinedAt,
      isPremium: isPremium ?? this.isPremium,
      totalPromptsGenerated:
          totalPromptsGenerated ?? this.totalPromptsGenerated,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'favoriteCategories': favoriteCategories,
      'favoritePrompts': favoritePrompts,
      'promptHistory': promptHistory,
      'joinedAt': joinedAt.toIso8601String(),
      'isPremium': isPremium,
      'totalPromptsGenerated': totalPromptsGenerated,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
      favoritePrompts: List<String>.from(json['favoritePrompts'] ?? []),
      promptHistory: List<String>.from(json['promptHistory'] ?? []),
      joinedAt: DateTime.parse(json['joinedAt']),
      isPremium: json['isPremium'] ?? false,
      totalPromptsGenerated: json['totalPromptsGenerated'] ?? 0,
    );
  }
}
