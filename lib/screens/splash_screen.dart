import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../config/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _textController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _controller.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Navigate after animations
    await Future.delayed(const Duration(seconds: 3));
    _navigateToOnboarding();
  }

  void _navigateToOnboarding() {
    Get.offAllNamed('/onboarding');
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundLinearGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animation
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryLinearGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),

              // App Name Animation
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textController.value,
                    child: Column(
                      children: [
                        // Main App Name
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return AppTheme.primaryLinearGradient
                                .createShader(bounds);
                          },
                          child: const Text(
                            'MYT AI',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle with Animated Text
                        SizedBox(
                          height: 30,
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'AI Prompt Generator',
                                textStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1,
                                ),
                                speed: const Duration(milliseconds: 100),
                              ),
                            ],
                            isRepeatingAnimation: false,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Loading indicator
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textController.value,
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _textController.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppTheme.primaryLinearGradient,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Initializing AI Engine...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
