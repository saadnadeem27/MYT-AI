import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../config/app_theme.dart';
import '../widgets/glass_widgets.dart';
import '../controllers/prompt_controller.dart';

class CustomizePromptScreen extends StatelessWidget {
  const CustomizePromptScreen({super.key});

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customize Prompt',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.tune_outlined,
                                      color: Colors.blue.shade300,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'AI Builder',
                                      style: TextStyle(
                                        color: Colors.blue.shade300,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Personalize your AI experience',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GlassIconButton(
                      icon: Icons.refresh,
                      onPressed: () => promptController.clearFilters(),
                    ),
                    const SizedBox(width: 8),
                    GlassIconButton(
                      icon: Icons.help_outline,
                      onPressed: () {
                        // Show help dialog
                      },
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Selection
                        AnimationConfiguration.staggeredList(
                          position: 0,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildCategorySection(promptController),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Type Selection
                        AnimationConfiguration.staggeredList(
                          position: 1,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildTypeSection(promptController),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Tone Selection
                        AnimationConfiguration.staggeredList(
                          position: 2,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildToneSection(promptController),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Style Selection
                        AnimationConfiguration.staggeredList(
                          position: 3,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildStyleSection(promptController),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Complexity Selection
                        AnimationConfiguration.staggeredList(
                          position: 4,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildComplexitySection(promptController),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Preview Section
                        AnimationConfiguration.staggeredList(
                          position: 5,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: _buildPreviewSection(promptController),
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
      floatingActionButton: Obx(() => Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: GradientButton(
              text: 'Generate Custom Prompt',
              onPressed: () async {
                final prompt = await promptController.generateRandomPrompt();
                if (prompt.isNotEmpty) {
                  Get.dialog(_buildGeneratedPromptDialog(prompt));
                }
              },
              isLoading: promptController.isGenerating.value,
              icon:
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCategorySection(PromptController promptController) {
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
                  Icons.category,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: promptController.categories.map((category) {
                  final isSelected =
                      promptController.selectedCategory.value == category;
                  return _buildSelectionChip(
                    label: category,
                    isSelected: isSelected,
                    onTap: () => promptController.setCategory(category),
                    gradient: AppTheme.primaryGradient,
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildTypeSection(PromptController promptController) {
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
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'AI Platform',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: promptController.types.map((type) {
                  final isSelected =
                      promptController.selectedType.value == type;
                  return _buildSelectionChip(
                    label: type,
                    isSelected: isSelected,
                    onTap: () => promptController.setType(type),
                    gradient: AppTheme.secondaryGradient,
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildToneSection(PromptController promptController) {
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
                  Icons.mood,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: promptController.tones.map((tone) {
                  final isSelected =
                      promptController.selectedTone.value == tone;
                  return _buildSelectionChip(
                    label: tone,
                    isSelected: isSelected,
                    onTap: () => promptController.setTone(tone),
                    gradient: [
                      const Color(0xFF667eea),
                      const Color(0xFF764ba2)
                    ],
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildStyleSection(PromptController promptController) {
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
                    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.brush,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Style',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: promptController.styles.map((style) {
                  final isSelected =
                      promptController.selectedStyle.value == style;
                  return _buildSelectionChip(
                    label: style,
                    isSelected: isSelected,
                    onTap: () => promptController.setStyle(style),
                    gradient: [
                      const Color(0xFF4ECDC4),
                      const Color(0xFF44A08D)
                    ],
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  Widget _buildComplexitySection(PromptController promptController) {
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
                  Icons.speed,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Complexity Level',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Simple',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Complex',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(Get.context!).copyWith(
                      activeTrackColor: Colors.orange.shade400,
                      inactiveTrackColor: Colors.white.withOpacity(0.2),
                      thumbColor: Colors.orange.shade400,
                      overlayColor: Colors.orange.shade400.withOpacity(0.3),
                      trackHeight: 4,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 8),
                    ),
                    child: Slider(
                      value:
                          promptController.selectedComplexity.value.toDouble(),
                      min: 1,
                      max: 3,
                      divisions: 2,
                      onChanged: (value) {
                        promptController.setComplexity(value.round());
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildComplexityLabel('1', 'Basic',
                          promptController.selectedComplexity.value == 1),
                      _buildComplexityLabel('2', 'Moderate',
                          promptController.selectedComplexity.value == 2),
                      _buildComplexityLabel('3', 'Advanced',
                          promptController.selectedComplexity.value == 3),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(PromptController promptController) {
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
                    colors: [Colors.purple.shade400, Colors.pink.shade400],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.preview,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Current Selection',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Column(
                children: [
                  _buildPreviewItem(
                      'Category', promptController.selectedCategory.value),
                  _buildPreviewItem(
                      'Platform', promptController.selectedType.value),
                  _buildPreviewItem(
                      'Tone', promptController.selectedTone.value),
                  _buildPreviewItem(
                      'Style', promptController.selectedStyle.value),
                  _buildPreviewItem('Complexity',
                      'Level ${promptController.selectedComplexity.value}'),
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildSelectionChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required List<Color> gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: gradient) : null,
          color: isSelected ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : Colors.white.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildComplexityLabel(String number, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color:
            isSelected ? Colors.orange.shade400 : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratedPromptDialog(String prompt) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Generated Custom Prompt',
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
    );
  }
}
