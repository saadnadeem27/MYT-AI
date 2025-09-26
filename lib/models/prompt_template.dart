class PromptTemplate {
  final String id;
  final String name;
  final String template;
  final String category;
  final String description;
  final List<String> placeholders;
  final DateTime createdAt;
  final bool isPremium;
  final int usageCount;

  PromptTemplate({
    required this.id,
    required this.name,
    required this.template,
    required this.category,
    required this.description,
    required this.placeholders,
    required this.createdAt,
    this.isPremium = false,
    this.usageCount = 0,
  });

  PromptTemplate copyWith({
    String? id,
    String? name,
    String? template,
    String? category,
    String? description,
    List<String>? placeholders,
    DateTime? createdAt,
    bool? isPremium,
    int? usageCount,
  }) {
    return PromptTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      template: template ?? this.template,
      category: category ?? this.category,
      description: description ?? this.description,
      placeholders: placeholders ?? this.placeholders,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'template': template,
      'category': category,
      'description': description,
      'placeholders': placeholders,
      'createdAt': createdAt.toIso8601String(),
      'isPremium': isPremium,
      'usageCount': usageCount,
    };
  }

  factory PromptTemplate.fromJson(Map<String, dynamic> json) {
    return PromptTemplate(
      id: json['id'],
      name: json['name'],
      template: json['template'],
      category: json['category'],
      description: json['description'],
      placeholders: List<String>.from(json['placeholders'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      isPremium: json['isPremium'] ?? false,
      usageCount: json['usageCount'] ?? 0,
    );
  }
}
