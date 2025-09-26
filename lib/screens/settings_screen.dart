import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../config/app_theme.dart';
import '../widgets/glass_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundLinearGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GlassIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimationLimiter(
                    child: Column(
                      children: [
                        // App Preferences
                        AnimationConfiguration.staggeredList(
                          position: 0,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildAppPreferencesSection(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // AI Settings
                        AnimationConfiguration.staggeredList(
                          position: 1,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildAISettingsSection(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Data & Privacy
                        AnimationConfiguration.staggeredList(
                          position: 2,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildDataPrivacySection(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // About & Support
                        AnimationConfiguration.staggeredList(
                          position: 3,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildAboutSupportSection(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppPreferencesSection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryLinearGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'App Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Always on for best experience',
            trailing: Switch(
              value: true,
              onChanged: null,
              activeColor: AppTheme.primaryColor,
            ),
          ),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Get updates about new features',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.primaryColor,
            ),
          ),
          _buildSettingItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => _showLanguageDialog(),
          ),
          _buildSettingItem(
            icon: Icons.text_fields,
            title: 'Font Size',
            subtitle: 'Medium',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => _showFontSizeDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildAISettingsSection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.secondaryLinearGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.smart_toy,
            title: 'Default AI Model',
            subtitle: 'ChatGPT',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => _showAIModelDialog(),
          ),
          _buildSettingItem(
            icon: Icons.tune,
            title: 'Response Quality',
            subtitle: 'Balanced',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => _showQualityDialog(),
          ),
          _buildSettingItem(
            icon: Icons.auto_awesome,
            title: 'Auto Suggestions',
            subtitle: 'Enable smart prompt suggestions',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.primaryColor,
            ),
          ),
          _buildSettingItem(
            icon: Icons.history,
            title: 'Save History',
            subtitle: 'Keep prompt generation history',
            trailing: Switch(
              value: true,
              onChanged: (value) {},
              activeColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPrivacySection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.security,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Data & Privacy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => Get.snackbar('Info', 'Opening privacy policy...'),
          ),
          _buildSettingItem(
            icon: Icons.description,
            title: 'Terms of Service',
            subtitle: 'View terms and conditions',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => Get.snackbar('Info', 'Opening terms of service...'),
          ),
          _buildSettingItem(
            icon: Icons.delete_forever,
            title: 'Clear Data',
            subtitle: 'Remove all saved prompts and history',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => _showClearDataDialog(),
          ),
          _buildSettingItem(
            icon: Icons.cloud_sync,
            title: 'Data Sync',
            subtitle: 'Sync data across devices',
            trailing: Switch(
              value: false,
              onChanged: (value) {},
              activeColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSupportSection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.red.shade400],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'About & Support',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: 'About MYT AI',
            subtitle: 'Version 1.0.0',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => _showAboutDialog(),
          ),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: 'Help & FAQ',
            subtitle: 'Get help with using the app',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => Get.snackbar('Info', 'Opening help center...'),
          ),
          _buildSettingItem(
            icon: Icons.feedback,
            title: 'Send Feedback',
            subtitle: 'Share your thoughts with us',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () => _showFeedbackDialog(),
          ),
          _buildSettingItem(
            icon: Icons.star_rate,
            title: 'Rate App',
            subtitle: 'Rate us on the app store',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () =>
                Get.snackbar('Thank you!', 'Redirecting to app store...'),
          ),
          _buildSettingItem(
            icon: Icons.share,
            title: 'Share App',
            subtitle: 'Share MYT AI with friends',
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
            onTap: () =>
                Get.snackbar('Success', 'Share link copied to clipboard'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...['English', 'Spanish', 'French', 'German', 'Chinese']
                  .map((lang) => ListTile(
                        title: Text(
                          lang,
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: Radio<String>(
                          value: lang,
                          groupValue: 'English',
                          onChanged: (value) => Get.back(),
                          activeColor: AppTheme.primaryColor,
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Font Size',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...['Small', 'Medium', 'Large', 'Extra Large']
                  .map((size) => ListTile(
                        title: Text(
                          size,
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: Radio<String>(
                          value: size,
                          groupValue: 'Medium',
                          onChanged: (value) => Get.back(),
                          activeColor: AppTheme.primaryColor,
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }

  void _showAIModelDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Default AI Model',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...['ChatGPT', 'GPT-4', 'Claude', 'Bard', 'MidJourney']
                  .map((model) => ListTile(
                        title: Text(
                          model,
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: Radio<String>(
                          value: model,
                          groupValue: 'ChatGPT',
                          onChanged: (value) => Get.back(),
                          activeColor: AppTheme.primaryColor,
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }

  void _showQualityDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Response Quality',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...['Fast', 'Balanced', 'Creative', 'Precise']
                  .map((quality) => ListTile(
                        title: Text(
                          quality,
                          style: const TextStyle(color: Colors.white),
                        ),
                        leading: Radio<String>(
                          value: quality,
                          groupValue: 'Balanced',
                          onChanged: (value) => Get.back(),
                          activeColor: AppTheme.primaryColor,
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearDataDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        content: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Clear All Data?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This will permanently delete all your saved prompts, favorites, and history. This action cannot be undone.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
                      text: 'Clear',
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                            'Success', 'All data cleared successfully');
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
  }

  void _showAboutDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryLinearGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'MYT AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your AI-powered prompt generation companion. Create, customize, and share intelligent prompts for all major AI platforms.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'OK',
                onPressed: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Send Feedback',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Tell us what you think...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      text: 'Send',
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                            'Thank you!', 'Feedback sent successfully');
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
}
