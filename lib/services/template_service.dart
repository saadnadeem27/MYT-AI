import '../models/prompt_template.dart';

class TemplateService {
  static final TemplateService _instance = TemplateService._internal();
  factory TemplateService() => _instance;
  TemplateService._internal();

  // Dummy template data
  final List<PromptTemplate> _dummyTemplates = [
    PromptTemplate(
      id: 't1',
      name: 'Blog Post Template',
      template:
          'Write a comprehensive blog post about {topic} targeting {audience}. Include an engaging introduction, {sections_count} main sections, and a compelling conclusion with a call-to-action. Tone: {tone}. Word count: approximately {word_count} words.',
      category: 'Writing',
      description:
          'Perfect for creating structured, engaging blog posts on any topic.',
      placeholders: [
        'topic',
        'audience',
        'sections_count',
        'tone',
        'word_count'
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isPremium: false,
      usageCount: 1247,
    ),
    PromptTemplate(
      id: 't2',
      name: 'Social Media Caption',
      template:
          'Create an engaging {platform} caption for {content_type} about {topic}. Include relevant hashtags, call-to-action, and maintain a {tone} tone. Target audience: {audience}. Keep it under {character_limit} characters.',
      category: 'Social Media',
      description:
          'Generate compelling social media captions for various platforms.',
      placeholders: [
        'platform',
        'content_type',
        'topic',
        'tone',
        'audience',
        'character_limit'
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isPremium: false,
      usageCount: 2156,
    ),
    PromptTemplate(
      id: 't3',
      name: 'Character Design Prompt',
      template:
          'Create a detailed character design for a {character_type} in {genre} style. Include: physical appearance, personality traits, background story, special abilities/skills, and their role in {setting}. Art style: {art_style}.',
      category: 'Art & Design',
      description:
          'Comprehensive character creation for stories, games, or artwork.',
      placeholders: ['character_type', 'genre', 'setting', 'art_style'],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isPremium: true,
      usageCount: 987,
    ),
    PromptTemplate(
      id: 't4',
      name: 'Code Review Template',
      template:
          'Review this {programming_language} code for {code_type}. Focus on: code quality, performance optimization, security concerns, best practices, and maintainability. Provide specific suggestions for improvement and rate the overall code quality.',
      category: 'Coding',
      description:
          'Comprehensive code review template for any programming language.',
      placeholders: ['programming_language', 'code_type'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isPremium: false,
      usageCount: 1534,
    ),
    PromptTemplate(
      id: 't5',
      name: 'Product Description',
      template:
          'Write a compelling product description for {product_name}, a {product_category} targeting {target_audience}. Highlight key features: {key_features}. Include benefits, unique selling points, and address common customer concerns. Tone: {tone}.',
      category: 'Marketing',
      description: 'Create persuasive product descriptions that convert.',
      placeholders: [
        'product_name',
        'product_category',
        'target_audience',
        'key_features',
        'tone'
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isPremium: false,
      usageCount: 1876,
    ),
    PromptTemplate(
      id: 't6',
      name: 'Business Plan Section',
      template:
          'Write the {section_name} section of a business plan for {business_type} called {company_name}. Target market: {target_market}. Include detailed analysis, strategic insights, and actionable recommendations. Make it professional and investor-ready.',
      category: 'Business',
      description:
          'Professional business plan sections for startups and established companies.',
      placeholders: [
        'section_name',
        'business_type',
        'company_name',
        'target_market'
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      isPremium: true,
      usageCount: 743,
    ),
    PromptTemplate(
      id: 't7',
      name: 'Lesson Plan Creator',
      template:
          'Create a detailed lesson plan for {subject} targeting {grade_level} students. Topic: {lesson_topic}. Duration: {duration}. Include learning objectives, materials needed, step-by-step activities, assessment methods, and homework assignment.',
      category: 'Education',
      description: 'Structured lesson plans for educators and trainers.',
      placeholders: ['subject', 'grade_level', 'lesson_topic', 'duration'],
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      isPremium: false,
      usageCount: 1098,
    ),
    PromptTemplate(
      id: 't8',
      name: 'Creative Story Prompt',
      template:
          'Write a {story_length} {genre} story about {main_character} who {inciting_incident}. Setting: {setting}. Include conflict, character development, and a satisfying resolution. Tone: {tone}. Target audience: {audience}.',
      category: 'Creative',
      description:
          'Generate engaging creative stories with structured elements.',
      placeholders: [
        'story_length',
        'genre',
        'main_character',
        'inciting_incident',
        'setting',
        'tone',
        'audience'
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isPremium: false,
      usageCount: 2301,
    ),
  ];

  Future<List<PromptTemplate>> getAllTemplates() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummyTemplates;
  }

  Future<PromptTemplate?> getTemplateById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _dummyTemplates.firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<PromptTemplate>> getTemplatesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category == 'All') return _dummyTemplates;
    return _dummyTemplates
        .where((template) => template.category == category)
        .toList();
  }

  Future<String> useTemplate(
      String templateId, Map<String, String> values) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final template = await getTemplateById(templateId);
    if (template == null) {
      throw Exception('Template not found');
    }

    String result = template.template;

    // Replace placeholders with values
    for (final entry in values.entries) {
      result = result.replaceAll('{${entry.key}}', entry.value);
    }

    // Update usage count
    final index = _dummyTemplates.indexWhere((t) => t.id == templateId);
    if (index != -1) {
      _dummyTemplates[index] = _dummyTemplates[index].copyWith(
        usageCount: _dummyTemplates[index].usageCount + 1,
      );
    }

    return result;
  }

  Future<List<PromptTemplate>> searchTemplates(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummyTemplates.where((template) {
      return template.name.toLowerCase().contains(query.toLowerCase()) ||
          template.description.toLowerCase().contains(query.toLowerCase()) ||
          template.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
