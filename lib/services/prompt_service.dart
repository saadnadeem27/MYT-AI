import '../models/prompt_model.dart';

class PromptService {
  static final PromptService _instance = PromptService._internal();
  factory PromptService() => _instance;
  PromptService._internal();

  // Dummy data for demonstration
  final List<PromptModel> _dummyPrompts = [
    // Writing Prompts
    PromptModel(
      id: '1',
      title: 'Creative Blog Post Generator',
      content:
          'Write a comprehensive blog post about [TOPIC] that engages readers with storytelling, includes practical tips, and ends with a compelling call-to-action. Target audience: [AUDIENCE]. Word count: [WORD_COUNT]. Tone: [TONE].',
      category: 'Writing',
      type: 'ChatGPT',
      tone: 'Professional',
      style: 'Detailed',
      complexity: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isFavorite: false,
      likes: 145,
      tags: ['blog', 'content', 'writing', 'marketing'],
      authorId: 'user1',
      authorName: 'Sarah Johnson',
    ),
    PromptModel(
      id: '2',
      title: 'Fantasy World Builder',
      content:
          'Create a detailed fantasy world with unique magic system, diverse cultures, and rich history. Include: geography, political systems, languages, and major conflicts. Style: [STYLE]. Target audience: [AUDIENCE].',
      category: 'Storytelling',
      type: 'ChatGPT',
      tone: 'Creative',
      style: 'Advanced',
      complexity: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isFavorite: true,
      likes: 289,
      tags: ['fantasy', 'worldbuilding', 'storytelling', 'creative'],
      authorId: 'user2',
      authorName: 'Michael Chen',
    ),
    // Art & Design Prompts
    PromptModel(
      id: '3',
      title: 'Cyberpunk Character Design',
      content:
          'Create a cyberpunk character portrait with neon lighting, futuristic clothing, and cybernetic enhancements. Style: digital art, highly detailed, 8k resolution. Mood: dark and atmospheric. Color palette: neon blues and purples.',
      category: 'Art & Design',
      type: 'MidJourney',
      tone: 'Creative',
      style: 'Advanced',
      complexity: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isFavorite: false,
      likes: 203,
      tags: ['cyberpunk', 'character', 'digital art', 'neon'],
      authorId: 'user3',
      authorName: 'Alex Rivera',
    ),
    PromptModel(
      id: '4',
      title: 'Minimalist Logo Designer',
      content:
          'Design a clean, minimalist logo for [COMPANY_NAME] in [INDUSTRY]. Use simple geometric shapes, limited color palette (max 2 colors), and ensure scalability. Style should convey [BRAND_VALUES].',
      category: 'Art & Design',
      type: 'DALL-E',
      tone: 'Professional',
      style: 'Simple',
      complexity: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      isFavorite: true,
      likes: 167,
      tags: ['logo', 'minimalist', 'branding', 'design'],
      authorId: 'user4',
      authorName: 'Emma Thompson',
    ),
    // Coding Prompts
    PromptModel(
      id: '5',
      title: 'React Component Generator',
      content:
          'Create a reusable React component for [COMPONENT_TYPE] with TypeScript support. Include: props interface, error handling, accessibility features, and unit tests. Follow best practices and modern React patterns.',
      category: 'Coding',
      type: 'ChatGPT',
      tone: 'Technical',
      style: 'Advanced',
      complexity: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isFavorite: false,
      likes: 312,
      tags: ['react', 'typescript', 'component', 'frontend'],
      authorId: 'user5',
      authorName: 'David Kim',
    ),
    // Marketing Prompts
    PromptModel(
      id: '6',
      title: 'Social Media Campaign Creator',
      content:
          'Design a 30-day social media campaign for [PRODUCT/SERVICE] targeting [AUDIENCE]. Include: content calendar, hashtag strategy, engagement tactics, and KPIs. Platforms: [PLATFORMS].',
      category: 'Marketing',
      type: 'ChatGPT',
      tone: 'Persuasive',
      style: 'Detailed',
      complexity: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      isFavorite: true,
      likes: 198,
      tags: ['social media', 'marketing', 'campaign', 'strategy'],
      authorId: 'user6',
      authorName: 'Lisa Wang',
    ),
    // Business Prompts
    PromptModel(
      id: '7',
      title: 'Business Plan Analyzer',
      content:
          'Analyze this business plan and provide detailed feedback on: market analysis, financial projections, competitive advantage, and growth strategy. Include actionable recommendations for improvement.',
      category: 'Business',
      type: 'ChatGPT',
      tone: 'Professional',
      style: 'Expert',
      complexity: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      isFavorite: false,
      likes: 156,
      tags: ['business plan', 'analysis', 'strategy', 'consulting'],
      authorId: 'user7',
      authorName: 'Robert Davis',
    ),
    // Education Prompts
    PromptModel(
      id: '8',
      title: 'Interactive Learning Module',
      content:
          'Create an interactive learning module about [SUBJECT] for [GRADE_LEVEL] students. Include: learning objectives, engaging activities, assessment questions, and multimedia suggestions.',
      category: 'Education',
      type: 'ChatGPT',
      tone: 'Friendly',
      style: 'Standard',
      complexity: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      isFavorite: false,
      likes: 89,
      tags: ['education', 'learning', 'interactive', 'curriculum'],
      authorId: 'user8',
      authorName: 'Jennifer Brown',
    ),
  ];

  Future<List<PromptModel>> getAllPrompts() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _dummyPrompts;
  }

  Future<PromptModel?> getPromptById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _dummyPrompts.firstWhere((prompt) => prompt.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<PromptModel>> getPromptsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category == 'All') return _dummyPrompts;
    return _dummyPrompts
        .where((prompt) => prompt.category == category)
        .toList();
  }

  Future<List<PromptModel>> searchPrompts(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _dummyPrompts.where((prompt) {
      return prompt.title.toLowerCase().contains(query.toLowerCase()) ||
          prompt.content.toLowerCase().contains(query.toLowerCase()) ||
          prompt.tags
              .any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  Future<String> generateRandomPrompt({
    String category = 'All',
    String type = 'All',
    String tone = 'Neutral',
    String style = 'Standard',
    int complexity = 1,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final prompts = <String>[
      'Create a comprehensive guide about ${_getRandomTopic()} that covers all essential aspects and provides actionable insights.',
      'Write an engaging story about ${_getRandomCharacter()} who discovers ${_getRandomDiscovery()} in a ${_getRandomSetting()}.',
      'Design a ${_getRandomArtStyle()} artwork featuring ${_getRandomSubject()} with ${_getRandomMood()} atmosphere.',
      'Develop a marketing strategy for ${_getRandomProduct()} targeting ${_getRandomAudience()} through ${_getRandomChannel()}.',
      'Build a ${_getRandomTech()} application that helps users ${_getRandomFunction()} with ${_getRandomFeature()} capabilities.',
      'Explain ${_getRandomConcept()} in simple terms that a ${_getRandomLevel()} can understand, using practical examples.',
      'Create a ${complexity > 2 ? 'detailed' : 'simple'} plan for ${_getRandomGoal()} within ${_getRandomTimeframe()}.',
      'Generate creative ideas for ${_getRandomProject()} that incorporates ${_getRandomTheme()} elements.',
    ];

    return prompts[DateTime.now().millisecondsSinceEpoch % prompts.length];
  }

  Future<PromptModel> toggleFavorite(String promptId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _dummyPrompts.indexWhere((p) => p.id == promptId);
    if (index != -1) {
      _dummyPrompts[index] = _dummyPrompts[index].copyWith(
        isFavorite: !_dummyPrompts[index].isFavorite,
      );
    }
    return _dummyPrompts[index];
  }

  Future<PromptModel> likePrompt(String promptId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _dummyPrompts.indexWhere((p) => p.id == promptId);
    if (index != -1) {
      _dummyPrompts[index] = _dummyPrompts[index].copyWith(
        likes: _dummyPrompts[index].likes + 1,
      );
    }
    return _dummyPrompts[index];
  }

  // Helper methods for random generation
  String _getRandomTopic() {
    final topics = [
      'artificial intelligence',
      'sustainable living',
      'digital marketing',
      'productivity',
      'creativity',
      'leadership',
      'innovation'
    ];
    return topics[DateTime.now().millisecondsSinceEpoch % topics.length];
  }

  String _getRandomCharacter() {
    final characters = [
      'a young inventor',
      'a space explorer',
      'a mysterious detective',
      'a magical librarian',
      'a time traveler',
      'a robot chef'
    ];
    return characters[
        DateTime.now().millisecondsSinceEpoch % characters.length];
  }

  String _getRandomDiscovery() {
    final discoveries = [
      'a hidden portal',
      'an ancient artifact',
      'a secret code',
      'a lost civilization',
      'a powerful technology',
      'a forgotten spell'
    ];
    return discoveries[
        DateTime.now().millisecondsSinceEpoch % discoveries.length];
  }

  String _getRandomSetting() {
    final settings = [
      'futuristic city',
      'enchanted forest',
      'abandoned space station',
      'underwater kingdom',
      'floating islands',
      'virtual reality world'
    ];
    return settings[DateTime.now().millisecondsSinceEpoch % settings.length];
  }

  String _getRandomArtStyle() {
    final styles = [
      'minimalist',
      'cyberpunk',
      'steampunk',
      'art nouveau',
      'surreal',
      'photorealistic'
    ];
    return styles[DateTime.now().millisecondsSinceEpoch % styles.length];
  }

  String _getRandomSubject() {
    final subjects = [
      'a majestic dragon',
      'a futuristic city',
      'a serene landscape',
      'a powerful warrior',
      'a magical creature',
      'a space battle'
    ];
    return subjects[DateTime.now().millisecondsSinceEpoch % subjects.length];
  }

  String _getRandomMood() {
    final moods = [
      'dramatic',
      'peaceful',
      'mysterious',
      'energetic',
      'melancholic',
      'inspiring'
    ];
    return moods[DateTime.now().millisecondsSinceEpoch % moods.length];
  }

  String _getRandomProduct() {
    final products = [
      'a fitness app',
      'eco-friendly products',
      'online courses',
      'smart home devices',
      'health supplements',
      'creative tools'
    ];
    return products[DateTime.now().millisecondsSinceEpoch % products.length];
  }

  String _getRandomAudience() {
    final audiences = [
      'young professionals',
      'busy parents',
      'college students',
      'entrepreneurs',
      'seniors',
      'creative professionals'
    ];
    return audiences[DateTime.now().millisecondsSinceEpoch % audiences.length];
  }

  String _getRandomChannel() {
    final channels = [
      'social media',
      'email campaigns',
      'content marketing',
      'influencer partnerships',
      'SEO',
      'paid advertising'
    ];
    return channels[DateTime.now().millisecondsSinceEpoch % channels.length];
  }

  String _getRandomTech() {
    final techs = ['mobile', 'web', 'AI-powered', 'blockchain', 'IoT', 'AR/VR'];
    return techs[DateTime.now().millisecondsSinceEpoch % techs.length];
  }

  String _getRandomFunction() {
    final functions = [
      'organize their tasks',
      'learn new skills',
      'connect with others',
      'manage finances',
      'stay healthy',
      'be more creative'
    ];
    return functions[DateTime.now().millisecondsSinceEpoch % functions.length];
  }

  String _getRandomFeature() {
    final features = [
      'AI recommendations',
      'real-time collaboration',
      'voice control',
      'personalization',
      'gamification',
      'offline sync'
    ];
    return features[DateTime.now().millisecondsSinceEpoch % features.length];
  }

  String _getRandomConcept() {
    final concepts = [
      'quantum computing',
      'machine learning',
      'blockchain technology',
      'sustainable energy',
      'space exploration',
      'genetic engineering'
    ];
    return concepts[DateTime.now().millisecondsSinceEpoch % concepts.length];
  }

  String _getRandomLevel() {
    final levels = [
      'beginner',
      'child',
      'teenager',
      'adult learner',
      'professional',
      'expert'
    ];
    return levels[DateTime.now().millisecondsSinceEpoch % levels.length];
  }

  String _getRandomGoal() {
    final goals = [
      'launching a startup',
      'learning a new language',
      'getting fit',
      'writing a book',
      'traveling the world',
      'building an audience'
    ];
    return goals[DateTime.now().millisecondsSinceEpoch % goals.length];
  }

  String _getRandomTimeframe() {
    final timeframes = [
      '30 days',
      '3 months',
      '6 months',
      '1 year',
      '2 years',
      'a weekend'
    ];
    return timeframes[
        DateTime.now().millisecondsSinceEpoch % timeframes.length];
  }

  String _getRandomProject() {
    final projects = [
      'a mobile app',
      'a website',
      'a marketing campaign',
      'a creative workshop',
      'a business plan',
      'an art installation'
    ];
    return projects[DateTime.now().millisecondsSinceEpoch % projects.length];
  }

  String _getRandomTheme() {
    final themes = [
      'sustainability',
      'technology',
      'community',
      'innovation',
      'wellness',
      'education',
      'creativity'
    ];
    return themes[DateTime.now().millisecondsSinceEpoch % themes.length];
  }
}
