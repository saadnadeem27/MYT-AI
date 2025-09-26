import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../config/app_theme.dart';
import '../controllers/navigation_controller.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/templates_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(NavigationController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundLinearGradient,
        ),
        child: Obx(() {
          switch (navigationController.selectedIndex.value) {
            case 0:
              return const HomeScreen();
            case 1:
              return ExploreScreen();
            case 2:
              return const FavoritesScreen();
            case 3:
              return TemplatesScreen();
            case 4:
              return const ProfileScreen();
            default:
              return const HomeScreen();
          }
        }),
      ),
      bottomNavigationBar:
          Obx(() => _buildBottomNavigationBar(navigationController)),
    );
  }

  Widget _buildBottomNavigationBar(NavigationController navigationController) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 75,
          borderRadius: 25,
          blur: 15,
          alignment: Alignment.bottomCenter,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.1),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
                index: 0,
                navigationController: navigationController,
              ),
              _buildNavItem(
                icon: Icons.explore_outlined,
                selectedIcon: Icons.explore,
                label: 'Explore',
                index: 1,
                navigationController: navigationController,
              ),
              _buildNavItem(
                icon: Icons.favorite_outline,
                selectedIcon: Icons.favorite,
                label: 'Favorites',
                index: 2,
                navigationController: navigationController,
              ),
              _buildNavItem(
                icon: Icons.description_outlined,
                selectedIcon: Icons.description,
                label: 'Templates',
                index: 3,
                navigationController: navigationController,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
                index: 4,
                navigationController: navigationController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required NavigationController navigationController,
  }) {
    final isSelected = navigationController.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => navigationController.changePage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: _getGradientColors(index),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _getGradientColors(index)[0].withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected),
                color: Colors.white,
                size: isSelected ? 26 : 22,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: Colors.white,
                fontSize: isSelected ? 11 : 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    switch (index) {
      case 0: // Home
        return AppTheme.primaryGradient;
      case 1: // Explore
        return [const Color(0xFF4ECDC4), const Color(0xFF44A08D)];
      case 2: // Favorites
        return [Colors.red.shade400, Colors.pink.shade400];
      case 3: // Templates
        return [Colors.purple.shade400, Colors.blue.shade400];
      case 4: // Profile
        return [const Color(0xFF667eea), const Color(0xFF764ba2)];
      default:
        return AppTheme.primaryGradient;
    }
  }
}
