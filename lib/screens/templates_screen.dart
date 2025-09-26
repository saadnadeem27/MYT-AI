import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../config/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../controllers/template_controller.dart';
import '../models/prompt_template.dart';

class TemplatesScreen extends StatelessWidget {
  TemplatesScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final templateController = Get.find<TemplateController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Search
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade400,
                              Colors.blue.shade400
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.shade400.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Templates',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.green.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Ready to Use',
                                        style: TextStyle(
                                          color: Colors.green.shade300,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '50+ Templates',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Professional prompt templates crafted by AI experts',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GlassSearchBar(
                    controller: _searchController,
                    hintText: 'Search templates...',
                    onChanged: (query) {
                      templateController.setSearchQuery(query);
                    },
                    onClear: () {
                      templateController.setSearchQuery('');
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTemplateStats(),
                ],
              ),
            ),

            // Category Filter
            _buildCategoryFilter(templateController),

            // Stats Section
            _buildStatsSection(templateController),
            SizedBox(height: 16),

            // Templates List
            Expanded(
              child: Obx(() {
                if (templateController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final templates = templateController.filteredTemplates;

                if (templates.isEmpty) {
                  return _buildEmptyState(templateController);
                }

                return AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _buildTemplateCard(
                                templates[index], templateController),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(TemplateController templateController) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: templateController.categories.length,
        itemBuilder: (context, index) {
          final category = templateController.categories[index];

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: Obx(() => CategoryChip(
                  label: category,
                  isSelected:
                      templateController.selectedCategory.value == category,
                  onTap: () => templateController.setCategory(category),
                )),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection(TemplateController templateController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final totalTemplates = templateController.allTemplates.length;
        final freeTemplates =
            templateController.allTemplates.where((t) => !t.isPremium).length;
        final premiumTemplates =
            templateController.allTemplates.where((t) => t.isPremium).length;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total',
                totalTemplates.toString(),
                Icons.description_outlined,
                [Colors.purple.shade400, Colors.blue.shade400],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Free',
                freeTemplates.toString(),
                Icons.free_breakfast,
                AppTheme.secondaryGradient,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Premium',
                premiumTemplates.toString(),
                Icons.star,
                [const Color(0xFFFFD700), const Color(0xFFFF8C00)],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, List<Color> gradient) {
    return GlassContainer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
      PromptTemplate template, TemplateController templateController) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.shade400,
                            Colors.blue.shade400
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        template.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (template.isPremium) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Premium',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${template.usageCount}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              template.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              template.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Placeholders
            if (template.placeholders.isNotEmpty) ...[
              Text(
                'Required fields:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: template.placeholders.take(5).map((placeholder) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '{$placeholder}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (template.placeholders.length > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+${template.placeholders.length - 5} more fields',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(template.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${template.placeholders.length} fields',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: template.isPremium ? 'Use Premium' : 'Use Template',
                    onPressed: () {
                      if (template.isPremium) {
                        _showPremiumDialog();
                      } else {
                        _showTemplateDialog(template, templateController);
                      }
                    },
                    height: 40,
                    gradient: template.isPremium
                        ? [const Color(0xFFFFD700), const Color(0xFFFF8C00)]
                        : [Colors.purple.shade400, Colors.blue.shade400],
                  ),
                ),
                const SizedBox(width: 8),
                GlassIconButton(
                  icon: Icons.visibility,
                  onPressed: () {
                    _showPreviewDialog(template);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(TemplateController templateController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade400, Colors.blue.shade400],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Templates Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search criteria\nor browse different categories',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Clear Filters',
              onPressed: () {
                templateController.clearFilters();
                _searchController.clear();
              },
              gradient: [Colors.purple.shade400, Colors.blue.shade400],
            ),
          ],
        ),
      ),
    );
  }

  void _showTemplateDialog(
      PromptTemplate template, TemplateController templateController) {
    final Map<String, TextEditingController> controllers = {};

    // Create controllers for each placeholder
    for (String placeholder in template.placeholders) {
      controllers[placeholder] = TextEditingController();
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: GlassContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        template.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  'Fill in the required fields:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Input fields
                ...template.placeholders.map((placeholder) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          placeholder.replaceAll('_', ' ').toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: controllers[placeholder],
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText:
                                'Enter ${placeholder.replaceAll('_', ' ')}',
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: 'Generate',
                        onPressed: () async {
                          final values = <String, String>{};
                          bool allFilled = true;

                          for (String placeholder in template.placeholders) {
                            final value =
                                controllers[placeholder]?.text.trim() ?? '';
                            if (value.isEmpty) {
                              allFilled = false;
                              break;
                            }
                            values[placeholder] = value;
                          }

                          if (!allFilled) {
                            Get.snackbar(
                                'Error', 'Please fill in all required fields');
                            return;
                          }

                          try {
                            final result = await templateController.useTemplate(
                                template.id, values);
                            Get.back();
                            _showGeneratedPromptDialog(result);
                          } catch (e) {
                            Get.snackbar(
                                'Error', 'Failed to generate prompt: $e');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    GlassIconButton(
                      icon: Icons.preview,
                      onPressed: () {
                        _showPreviewDialog(template);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPreviewDialog(PromptTemplate template) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Template Preview',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                template.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                template.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Template:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      template.template,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGeneratedPromptDialog(String prompt) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Generated Prompt',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  prompt,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      text: 'Copy',
                      onPressed: () {
                        Get.back();
                        Get.snackbar('Success', 'Prompt copied to clipboard');
                      },
                      gradient: AppTheme.secondaryGradient,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientButton(
                      text: 'Share',
                      onPressed: () {
                        Get.back();
                        Get.snackbar('Success', 'Prompt shared successfully');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPremiumDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Premium Template',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This template requires a premium subscription.\nUpgrade to unlock all premium features!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      text: 'Maybe Later',
                      onPressed: () => Get.back(),
                      gradient: [Colors.grey.shade600, Colors.grey.shade700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientButton(
                      text: 'Upgrade Now',
                      onPressed: () {
                        Get.back();
                        Get.snackbar('Premium', 'Premium upgrade coming soon!');
                      },
                      gradient: const [Color(0xFFFFD700), Color(0xFFFF8C00)],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateStats() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.trending_up_rounded,
                  color: Colors.green.shade300,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Most Popular',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.new_releases_outlined,
                  color: Colors.blue.shade300,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Recent',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star_outline_rounded,
                  color: Colors.yellow.shade300,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Top Rated',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
