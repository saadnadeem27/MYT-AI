import 'package:get/get.dart';
import '../models/prompt_model.dart';
import '../services/prompt_service.dart';

class PromptController extends GetxController {
  final PromptService _promptService = Get.find<PromptService>();

  // Observable variables
  final RxList<PromptModel> allPrompts = <PromptModel>[].obs;
  final RxList<PromptModel> filteredPrompts = <PromptModel>[].obs;
  final RxList<PromptModel> favoritePrompts = <PromptModel>[].obs;
  final RxList<PromptModel> trendingPrompts = <PromptModel>[].obs;
  final RxList<PromptModel> recentPrompts = <PromptModel>[].obs;

  final RxString selectedCategory = 'All'.obs;
  final RxString selectedType = 'All'.obs;
  final RxString selectedTone = 'Neutral'.obs;
  final RxString selectedStyle = 'Standard'.obs;
  final RxInt selectedComplexity = 1.obs;
  final RxString searchQuery = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isGenerating = false.obs;

  final RxString lastGeneratedPrompt = ''.obs;

  // Categories
  final List<String> categories = [
    'All',
    'Writing',
    'Coding',
    'Art & Design',
    'Marketing',
    'Storytelling',
    'Business',
    'Education',
    'Social Media',
    'Creative',
    'Technical',
    'Research'
  ];

  // Types
  final List<String> types = [
    'All',
    'ChatGPT',
    'MidJourney',
    'DALL-E',
    'Stable Diffusion',
    'Claude',
    'GPT-4',
    'Bard'
  ];

  // Tones
  final List<String> tones = [
    'Neutral',
    'Professional',
    'Casual',
    'Friendly',
    'Formal',
    'Creative',
    'Humorous',
    'Serious',
    'Inspiring',
    'Persuasive'
  ];

  // Styles
  final List<String> styles = [
    'Standard',
    'Detailed',
    'Concise',
    'Technical',
    'Simple',
    'Advanced',
    'Beginner',
    'Expert'
  ];

  @override
  void onInit() {
    super.onInit();
    loadPrompts();

    // Listen to search changes
    debounce(searchQuery, (_) => filterPrompts(),
        time: const Duration(milliseconds: 500));
  }

  Future<void> loadPrompts() async {
    try {
      isLoading.value = true;
      final prompts = await _promptService.getAllPrompts();
      allPrompts.assignAll(prompts);
      filterPrompts();
      loadFavorites();
      loadTrending();
      loadRecent();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load prompts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterPrompts() {
    var filtered = allPrompts.where((prompt) {
      final matchesCategory = selectedCategory.value == 'All' ||
          prompt.category == selectedCategory.value;
      final matchesType =
          selectedType.value == 'All' || prompt.type == selectedType.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          prompt.title
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          prompt.content
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          prompt.tags.any((tag) =>
              tag.toLowerCase().contains(searchQuery.value.toLowerCase()));

      return matchesCategory && matchesType && matchesSearch;
    }).toList();

    filteredPrompts.assignAll(filtered);
  }

  void loadFavorites() {
    final favorites = allPrompts.where((prompt) => prompt.isFavorite).toList();
    favoritePrompts.assignAll(favorites);
  }

  void loadTrending() {
    final trending = allPrompts.toList()
      ..sort((a, b) => b.likes.compareTo(a.likes));
    trendingPrompts.assignAll(trending.take(10).toList());
  }

  void loadRecent() {
    final recent = allPrompts.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    recentPrompts.assignAll(recent.take(10).toList());
  }

  Future<String> generateRandomPrompt() async {
    try {
      isGenerating.value = true;
      final prompt = await _promptService.generateRandomPrompt(
        category: selectedCategory.value,
        type: selectedType.value,
        tone: selectedTone.value,
        style: selectedStyle.value,
        complexity: selectedComplexity.value,
      );
      lastGeneratedPrompt.value = prompt;
      return prompt;
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate prompt: $e');
      return '';
    } finally {
      isGenerating.value = false;
    }
  }

  Future<void> toggleFavorite(PromptModel prompt) async {
    try {
      final updatedPrompt = await _promptService.toggleFavorite(prompt.id);
      final index = allPrompts.indexWhere((p) => p.id == prompt.id);
      if (index != -1) {
        allPrompts[index] = updatedPrompt;
        filterPrompts();
        loadFavorites();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite: $e');
    }
  }

  Future<void> likePrompt(PromptModel prompt) async {
    try {
      final updatedPrompt = await _promptService.likePrompt(prompt.id);
      final index = allPrompts.indexWhere((p) => p.id == prompt.id);
      if (index != -1) {
        allPrompts[index] = updatedPrompt;
        filterPrompts();
        loadTrending();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to like prompt: $e');
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    filterPrompts();
  }

  void setType(String type) {
    selectedType.value = type;
    filterPrompts();
  }

  void setTone(String tone) {
    selectedTone.value = tone;
  }

  void setStyle(String style) {
    selectedStyle.value = style;
  }

  void setComplexity(int complexity) {
    selectedComplexity.value = complexity;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearFilters() {
    selectedCategory.value = 'All';
    selectedType.value = 'All';
    selectedTone.value = 'Neutral';
    selectedStyle.value = 'Standard';
    selectedComplexity.value = 1;
    searchQuery.value = '';
    filterPrompts();
  }
}
