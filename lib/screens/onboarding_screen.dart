import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../config/app_theme.dart';
import '../widgets/glass_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'AI-Powered Prompt Generation',
      description:
          'Leverage advanced AI technology to create high-quality prompts for ChatGPT, MidJourney, DALL-E, and other leading AI platforms. Transform your ideas into professional results.',
      icon: Icons.auto_awesome,
      gradient: AppTheme.primaryGradient,
    ),
    OnboardingItem(
      title: 'Discover & Explore',
      description:
          'Access a curated library of premium prompts created by AI experts. Find trending content across marketing, design, writing, coding, and creative categories.',
      icon: Icons.explore,
      gradient: [const Color(0xFF4ECDC4), const Color(0xFF44A08D)],
    ),
    OnboardingItem(
      title: 'Personal Collections',
      description:
          'Build your personal vault of favorite prompts. Organize, categorize, and access your most valuable AI assets with intelligent search and filtering.',
      icon: Icons.favorite,
      gradient: [Colors.red.shade400, Colors.pink.shade400],
    ),
    OnboardingItem(
      title: 'Professional Templates',
      description:
          'Accelerate your workflow with expertly crafted templates. Industry-standard formats for business, creative, technical, and educational applications.',
      icon: Icons.description,
      gradient: [Colors.purple.shade400, Colors.blue.shade400],
    ),
  ];

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
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () => _skipOnboarding(),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingItems.length,
                  itemBuilder: (context, index) {
                    return AnimationLimiter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon
                            AnimationConfiguration.staggeredList(
                              position: 0,
                              child: SlideAnimation(
                                verticalOffset: 100,
                                child: FadeInAnimation(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors:
                                            _onboardingItems[index].gradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: _onboardingItems[index]
                                              .gradient[0]
                                              .withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _onboardingItems[index].icon,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),

                            // Title
                            AnimationConfiguration.staggeredList(
                              position: 1,
                              child: SlideAnimation(
                                verticalOffset: 50,
                                child: FadeInAnimation(
                                  child: Text(
                                    _onboardingItems[index].title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Description
                            AnimationConfiguration.staggeredList(
                              position: 2,
                              child: SlideAnimation(
                                verticalOffset: 50,
                                child: FadeInAnimation(
                                  child: Text(
                                    _onboardingItems[index].description,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.8),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Page indicator and buttons
              Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onboardingItems.length,
                        (index) => Container(
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppTheme.primaryColor
                                : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Buttons
                    Row(
                      children: [
                        // Previous button
                        if (_currentPage > 0) ...[
                          Expanded(
                            child: GradientButton(
                              text: 'Previous',
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              gradient: [
                                Colors.grey.shade600,
                                Colors.grey.shade700
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],

                        // Next/Get Started button
                        Expanded(
                          flex: _currentPage > 0 ? 1 : 2,
                          child: GradientButton(
                            text: _currentPage == _onboardingItems.length - 1
                                ? 'Get Started'
                                : 'Next',
                            onPressed: () {
                              if (_currentPage == _onboardingItems.length - 1) {
                                _completeOnboarding();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            gradient: _onboardingItems[_currentPage].gradient,
                          ),
                        ),
                      ],
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

  void _skipOnboarding() {
    Get.offAllNamed('/main');
  }

  void _completeOnboarding() {
    // In a real app, you'd save that onboarding is completed
    Get.offAllNamed('/main');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
