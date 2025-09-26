import 'package:get/get.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/templates_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/customize_prompt_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String main = '/main';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String favorites = '/favorites';
  static const String templates = '/templates';
  static const String profile = '/profile';
  static const String customize = '/customize';
  static const String settings = '/settings';

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: main,
      page: () => const MainNavigationScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: explore,
      page: () => ExploreScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: favorites,
      page: () => const FavoritesScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: templates,
      page: () => TemplatesScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: customize,
      page: () => const CustomizePromptScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
