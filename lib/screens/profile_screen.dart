import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../config/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../controllers/user_controller.dart';
import '../controllers/prompt_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final promptController = Get.find<PromptController>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundLinearGradient,
        ),
        child: SafeArea(
          child: Obx(() {
            final user = userController.currentUser.value;
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: AnimationLimiter(
                child: Column(
                  children: [
                    // Profile Header
                    AnimationConfiguration.staggeredList(
                      position: 0,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildProfileHeader(user),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Stats Section
                    AnimationConfiguration.staggeredList(
                      position: 1,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildStatsSection(user),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Achievements Section
                    AnimationConfiguration.staggeredList(
                      position: 2,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildAchievementsSection(user),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Recent Activity
                    AnimationConfiguration.staggeredList(
                      position: 3,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildRecentActivity(user, promptController),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Settings Section
                    AnimationConfiguration.staggeredList(
                      position: 4,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildSettingsSection(userController),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Logout Button
                    AnimationConfiguration.staggeredList(
                      position: 5,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildLogoutButton(userController),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return GlassContainer(
      child: Column(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryLinearGradient,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 3,
                  ),
                ),
                child: user.avatar != null
                    ? ClipOval(
                        child: Image.network(
                          user.avatar!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppTheme.secondaryLinearGradient,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name and Email
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),

          // Premium Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: user.isPremium
                      ? const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade600, Colors.grey.shade700],
                        ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      user.isPremium ? Icons.star : Icons.person,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.isPremium ? 'Premium Member' : 'Free Member',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Member Since
          Text(
            'Member since ${_formatDate(user.joinedAt)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Stats',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Prompts Generated',
                user.totalPromptsGenerated.toString(),
                Icons.auto_awesome,
                AppTheme.primaryGradient,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Favorites',
                user.favoritePrompts.length.toString(),
                Icons.favorite,
                [Colors.red.shade400, Colors.pink.shade400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Categories',
                user.favoriteCategories.length.toString(),
                Icons.category,
                AppTheme.secondaryGradient,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'History Items',
                user.promptHistory.length.toString(),
                Icons.history,
                [const Color(0xFF6C63FF), const Color(0xFF9C27B0)],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, List<Color> gradient) {
    return GlassContainer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
              size: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(user) {
    final achievements = _getAchievements(user);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 16),
                child: GlassContainer(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: achievement['unlocked']
                                ? achievement['gradient']
                                : [Colors.grey.shade600, Colors.grey.shade700],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          achievement['icon'],
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement['title'],
                        style: TextStyle(
                          fontSize: 10,
                          color: achievement['unlocked']
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(user, promptController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                _showFullHistory(user, promptController);
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassContainer(
          child: Column(
            children: user.promptHistory.take(5).map<Widget>((promptId) {
              // In a real app, you'd fetch the actual prompt details
              return _buildActivityItem(
                'Generated prompt',
                'Used ChatGPT prompt template',
                Icons.auto_awesome,
                DateTime.now().subtract(Duration(hours: user.promptHistory.indexOf(promptId))),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, DateTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryLinearGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTimeAgo(time),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(UserController userController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GlassContainer(
          child: Column(
            children: [
              _buildSettingsItem(
                Icons.person_outline,
                'Edit Profile',
                'Update your personal information',
                () {
                  _showEditProfileDialog(userController);
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                Icons.notifications_outlined,
                'Notifications',
                'Manage notification preferences',
                () {
                  Get.snackbar('Settings', 'Notification settings coming soon');
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                Icons.star_outline,
                'Upgrade to Premium',
                'Unlock premium features',
                () {
                  _showPremiumDialog();
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                Icons.help_outline,
                'Help & Support',
                'Get help and contact support',
                () {
                  Get.snackbar('Support', 'Help & Support coming soon');
                },
              ),
              _buildDivider(),
              _buildSettingsItem(
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                'Read our privacy policy',
                () {
                  Get.snackbar('Privacy', 'Privacy policy coming soon');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }

  Widget _buildLogoutButton(UserController userController) {
    return GradientButton(
      text: 'Logout',
      onPressed: () {
        Get.dialog(
          Dialog(
            backgroundColor: Colors.transparent,
            child: GlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          text: 'Cancel',
                          onPressed: () => Get.back(),
                          gradient: [Colors.grey.shade600, Colors.grey.shade700],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GradientButton(
                          text: 'Logout',
                          onPressed: () {
                            userController.logout();
                            Get.back();
                            Get.snackbar('Success', 'Logged out successfully');
                          },
                          gradient: [Colors.red.shade400, Colors.red.shade600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      gradient: [Colors.red.shade400, Colors.red.shade600],
      icon: const Icon(Icons.logout, color: Colors.white, size: 20),
    );
  }

  void _showEditProfileDialog(UserController userController) {
    final nameController = TextEditingController(text: userController.currentUser.value?.name);
    final emailController = TextEditingController(text: userController.currentUser.value?.email);

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(color: AppTheme.primaryColor),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: AppTheme.primaryColor),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      text: 'Cancel',
                      onPressed: () => Get.back(),
                      gradient: [Colors.grey.shade600, Colors.grey.shade700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientButton(
                      text: 'Save',
                      onPressed: () {
                        final user = userController.currentUser.value;
                        if (user != null) {
                          final updatedUser = user.copyWith(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                          );
                          userController.updateUser(updatedUser);
                        }
                        Get.back();
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
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upgrade to Premium',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Unlock premium features:\n• Unlimited prompt generation\n• Premium templates\n• Advanced customization\n• Priority support',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
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

  void _showFullHistory(user, promptController) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: Get.height * 0.7,
          child: GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activity History',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: user.promptHistory.length,
                    itemBuilder: (context, index) {
                      return _buildActivityItem(
                        'Generated prompt',
                        'Used template or generated random prompt',
                        Icons.auto_awesome,
                        DateTime.now().subtract(Duration(hours: index)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                GradientButton(
                  text: 'Close',
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAchievements(user) {
    return [
      {
        'title': 'First Steps',
        'icon': Icons.rocket_launch,
        'gradient': AppTheme.primaryGradient,
        'unlocked': user.totalPromptsGenerated >= 1,
      },
      {
        'title': 'Prompt Master',
        'icon': Icons.auto_awesome,
        'gradient': AppTheme.secondaryGradient,
        'unlocked': user.totalPromptsGenerated >= 10,
      },
      {
        'title': 'Explorer',
        'icon': Icons.explore,
        'gradient': [Colors.green.shade400, Colors.blue.shade400],
        'unlocked': user.favoriteCategories.length >= 3,
      },
      {
        'title': 'Collector',
        'icon': Icons.favorite,
        'gradient': [Colors.red.shade400, Colors.pink.shade400],
        'unlocked': user.favoritePrompts.length >= 5,
      },
      {
        'title': 'Veteran',
        'icon': Icons.military_tech,
        'gradient': [const Color(0xFFFFD700), const Color(0xFFFF8C00)],
        'unlocked': user.totalPromptsGenerated >= 50,
      },
    ];
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

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