import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }

  // Navigation items
  final List<NavigationItem> navigationItems = [
    NavigationItem(
      icon: 'home',
      label: 'Home',
      route: '/home',
    ),
    NavigationItem(
      icon: 'explore',
      label: 'Explore',
      route: '/explore',
    ),
    NavigationItem(
      icon: 'favorite',
      label: 'Favorites',
      route: '/favorites',
    ),
    NavigationItem(
      icon: 'template',
      label: 'Templates',
      route: '/templates',
    ),
    NavigationItem(
      icon: 'profile',
      label: 'Profile',
      route: '/profile',
    ),
  ];
}

class NavigationItem {
  final String icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
