import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../config/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../controllers/prompt_controller.dart';
import '../controllers/user_controller.dart';
import '../models/prompt_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final promptController = Get.find<PromptController>();
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                            colors: [Colors.red.shade400, Colors.pink.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade400.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
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
                              'My Favorites',
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
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red.shade300,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Curated',
                                        style: TextStyle(
                                          color: Colors.red.shade300,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Obx(() => Text(
                                      '${promptController.favoritePrompts.length} saved',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your personally curated collection of AI prompts',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Stats Section
            _buildStatsSection(userController),

            // Favorite Categories
            _buildFavoriteCategoriesSection(userController, promptController),

            // Favorites List
            Expanded(
              child: Obx(() {
                if (promptController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final favorites = promptController.favoritePrompts;

                if (favorites.isEmpty) {
                  return _buildEmptyState();
                }

                return AnimationLimiter(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: _buildFavoriteCard(
                                favorites[index], promptController),
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

  Widget _buildStatsSection(UserController userController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final user = userController.currentUser.value;
        if (user == null) return const SizedBox.shrink();

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Favorites',
                user.favoritePrompts.length.toString(),
                Icons.bookmark,
                [Colors.red.shade400, Colors.pink.shade400],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Categories',
                user.favoriteCategories.length.toString(),
                Icons.category,
                AppTheme.primaryGradient,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'This Week',
                '12', // Mock data
                Icons.trending_up,
                AppTheme.secondaryGradient,
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

  Widget _buildFavoriteCategoriesSection(
      UserController userController, PromptController promptController) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorite Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final favoriteCategories =
                userController.currentUser.value?.favoriteCategories ?? [];

            if (favoriteCategories.isEmpty) {
              return GlassContainer(
                child: Text(
                  'No favorite categories yet. Explore prompts to add categories!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: favoriteCategories.length,
                itemBuilder: (context, index) {
                  final category = favoriteCategories[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: CategoryChip(
                      label: category,
                      isSelected: true,
                      onTap: () {
                        promptController.setCategory(category);
                        Get.toNamed('/explore');
                      },
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(
      PromptModel prompt, PromptController promptController) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with favorite toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red.shade400, Colors.pink.shade400],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => promptController.toggleFavorite(prompt),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.remove,
                          color: Colors.red,
                          size: 16,
                        ),
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

            // Content preview
            Text(
              prompt.content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Tags
            if (prompt.tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: prompt.tags.take(3).map((tag) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${prompt.likes} likes',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
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
            const SizedBox(height: 12),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                    text: 'Use Prompt',
                    onPressed: () {
                      Get.dialog(_buildPromptDialog(prompt, promptController));
                    },
                    height: 50,
                    gradient: [Colors.red.shade400, Colors.pink.shade400],
                  ),
                ),
                const SizedBox(width: 8),
                GlassIconButton(
                  icon: Icons.share,
                  onPressed: () {
                    Get.snackbar('Share', 'Prompt shared successfully');
                  },
                ),
                const SizedBox(width: 8),
                GlassIconButton(
                  icon: Icons.edit,
                  onPressed: () {
                    // Edit functionality
                    Get.snackbar('Edit', 'Edit functionality coming soon');
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
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.pink.shade400],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore amazing prompts and save your favorites here.\nTap the bookmark icon on any prompt to add it.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Explore Prompts',
              onPressed: () {
                Get.toNamed('/explore');
              },
              gradient: [Colors.red.shade400, Colors.pink.shade400],
              icon: const Icon(Icons.explore, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromptDialog(
      PromptModel prompt, PromptController promptController) {
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
                    text: 'Remove',
                    onPressed: () {
                      promptController.toggleFavorite(prompt);
                      Get.back();
                      Get.snackbar('Removed', 'Prompt removed from favorites');
                    },
                    gradient: [Colors.red.shade400, Colors.pink.shade600],
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
}
