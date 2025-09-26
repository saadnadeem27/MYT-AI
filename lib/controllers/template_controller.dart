import 'package:get/get.dart';
import '../models/prompt_template.dart';
import '../services/template_service.dart';

class TemplateController extends GetxController {
  final TemplateService _templateService = Get.find<TemplateService>();

  // Observable variables
  final RxList<PromptTemplate> allTemplates = <PromptTemplate>[].obs;
  final RxList<PromptTemplate> filteredTemplates = <PromptTemplate>[].obs;
  final RxList<PromptTemplate> popularTemplates = <PromptTemplate>[].obs;
  final RxList<PromptTemplate> recentTemplates = <PromptTemplate>[].obs;

  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  final List<String> categories = [
    'All',
    'Writing',
    'Coding',
    'Art & Design',
    'Marketing',
    'Business',
    'Education',
    'Social Media',
    'Creative',
  ];

  @override
  void onInit() {
    super.onInit();
    loadTemplates();

    // Listen to search changes
    debounce(searchQuery, (_) => filterTemplates(),
        time: const Duration(milliseconds: 500));
  }

  Future<void> loadTemplates() async {
    try {
      isLoading.value = true;
      final templates = await _templateService.getAllTemplates();
      allTemplates.assignAll(templates);
      filterTemplates();
      loadPopular();
      loadRecent();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load templates: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void filterTemplates() {
    var filtered = allTemplates.where((template) {
      final matchesCategory = selectedCategory.value == 'All' ||
          template.category == selectedCategory.value;
      final matchesSearch = searchQuery.value.isEmpty ||
          template.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          template.description
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    filteredTemplates.assignAll(filtered);
  }

  void loadPopular() {
    final popular = allTemplates.toList()
      ..sort((a, b) => b.usageCount.compareTo(a.usageCount));
    popularTemplates.assignAll(popular.take(10).toList());
  }

  void loadRecent() {
    final recent = allTemplates.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    recentTemplates.assignAll(recent.take(10).toList());
  }

  Future<String> useTemplate(
      String templateId, Map<String, String> values) async {
    try {
      final result = await _templateService.useTemplate(templateId, values);
      return result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to use template: $e');
      return '';
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    filterTemplates();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearFilters() {
    selectedCategory.value = 'All';
    searchQuery.value = '';
    filterTemplates();
  }
}
