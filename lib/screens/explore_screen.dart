import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../config/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../controllers/prompt_controller.dart';
import '../models/prompt_model.dart';

class ExploreScreen extends StatelessWidget {
  ExploreScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final promptController = Get.find<PromptController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundLinearGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Search
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explore Prompts',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover amazing AI prompts from our community',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassSearchBar(
                      controller: _searchController,
                      hintText: 'Search prompts, categories, or authors...',
                      onChanged: (query) {
                        promptController.setSearchQuery(query);
                      },
                      onClear: () {
                        promptController.setSearchQuery('');
                      },
                    ),
                  ],
                ),
              ),

              // Category Filter
              _buildCategoryFilter(promptController),

              // Type Filter
              _buildTypeFilter(promptController),

              // Results
              Expanded(
                child: Obx(() {
                  if (promptController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final prompts = promptController.filteredPrompts;

                  if (prompts.isEmpty) {
                    return _buildEmptyState();
                  }

                  return AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: prompts.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildPromptCard(prompts[index], promptController),
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
      ),
      floatingActionButton: Obx(() => promptController.filteredPrompts.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                promptController.clearFilters();
                _searchController.clear();
              },
              backgroundColor: AppTheme.primaryColor,
              icon: const Icon(Icons.clear_all, color: Colors.white),
              label: const Text(
                'Clear Filters',
                style: TextStyle(color: Colors.white),
              ),
            )
          : const SizedBox.shrink()),
    );
  }

  Widget _buildCategoryFilter(PromptController promptController) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 16),
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: promptController.categories.length,
            itemBuilder: (context, index) {
              final category = promptController.categories[index];
              final isSelected = promptController.selectedCategory.value == category;
              
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: CategoryChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () => promptController.setCategory(category),
                ),
              );
            },
          )),
    );
  }

  Widget _buildTypeFilter(PromptController promptController) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 20),
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: promptController.types.length,
            itemBuilder: (context, index) {
              final type = promptController.types[index];
              final isSelected = promptController.selectedType.value == type;
              
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => promptController.setType(type),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.secondaryColor.withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.secondaryColor
                            : Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppTheme.secondaryColor
                            : Colors.white.withOpacity(0.8),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  Widget _buildPromptCard(PromptModel prompt, PromptController promptController) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryLinearGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        prompt.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        prompt.type,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => promptController.likePrompt(prompt),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            color: Colors.red,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            prompt.likes.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => promptController.toggleFavorite(prompt),
                      child: Icon(
                        prompt.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                        color: prompt.isFavorite ? AppTheme.secondaryColor : Colors.white70,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              prompt.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Content
            Text(
              prompt.content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Tags
            if (prompt.tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: prompt.tags.take(5).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'by ${prompt.authorName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      _formatDate(prompt.createdAt),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Complexity indicator
                    ...List.generate(3, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: index < prompt.complexity
                              ? AppTheme.primaryColor
                              : Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getToneColor(prompt.tone).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            prompt.tone,
                            style: TextStyle(
                              fontSize: 10,
                              color: _getToneColor(prompt.tone),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStyleColor(prompt.style).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            prompt.style,
                            style: TextStyle(
                              fontSize: 10,
                              color: _getStyleColor(prompt.style),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
                    text: 'Use Prompt',
                    onPressed: () {
                      Get.dialog(_buildPromptDialog(prompt));
                    },
                    height: 40,
                  ),
                ),
                const SizedBox(width: 8),
                GlassIconButton(
                  icon: Icons.share,
                  onPressed: () {
                    // Share functionality
                    Get.snackbar('Share', 'Prompt shared successfully');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryLinearGradient,
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
            'No prompts found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria\nor clear the filters',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: 'Clear All Filters',
            onPressed: () {
              final promptController = Get.find<PromptController>();
              promptController.clearFilters();
              _searchController.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPromptDialog(PromptModel prompt) {
    return Dialog(
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
                    prompt.title,
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
                    'Prompt Content:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    prompt.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Category: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryLinearGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    prompt.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Type: ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    prompt.type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: 'Copy',
                    onPressed: () {
                      // Copy to clipboard logic
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
                      // Share logic
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

  Color _getToneColor(String tone) {
    switch (tone.toLowerCase()) {
      case 'professional':
        return const Color(0xFF4A90E2);
      case 'casual':
        return const Color(0xFF7ED321);
      case 'friendly':
        return const Color(0xFFFF9500);
      case 'creative':
        return const Color(0xFF9013FE);
      case 'serious':
        return const Color(0xFF546E7A);
      default:
        return Colors.white70;
    }
  }

  Color _getStyleColor(String style) {
    switch (style.toLowerCase()) {
      case 'detailed':
        return const Color(0xFFE91E63);
      case 'simple':
        return const Color(0xFF4CAF50);
      case 'advanced':
        return const Color(0xFFFF5722);
      case 'technical':
        return const Color(0xFF2196F3);
      default:
        return Colors.white70;
    }
  }
}