import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  // Observable variables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    try {
      isLoading.value = true;
      final user = await _userService.getCurrentUser();
      if (user != null) {
        currentUser.value = user;
        isLoggedIn.value = true;
      }
    } catch (e) {
      print('Error loading user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      isLoading.value = true;
      final updatedUser = await _userService.updateUser(user);
      currentUser.value = updatedUser;
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToFavorites(String promptId) async {
    if (currentUser.value != null) {
      try {
        final updatedFavorites = [...currentUser.value!.favoritePrompts];
        if (!updatedFavorites.contains(promptId)) {
          updatedFavorites.add(promptId);
          final updatedUser = currentUser.value!.copyWith(
            favoritePrompts: updatedFavorites,
          );
          await updateUser(updatedUser);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to add to favorites: $e');
      }
    }
  }

  Future<void> removeFromFavorites(String promptId) async {
    if (currentUser.value != null) {
      try {
        final updatedFavorites = [...currentUser.value!.favoritePrompts];
        updatedFavorites.remove(promptId);
        final updatedUser = currentUser.value!.copyWith(
          favoritePrompts: updatedFavorites,
        );
        await updateUser(updatedUser);
      } catch (e) {
        Get.snackbar('Error', 'Failed to remove from favorites: $e');
      }
    }
  }

  Future<void> addToHistory(String promptId) async {
    if (currentUser.value != null) {
      try {
        final updatedHistory = [...currentUser.value!.promptHistory];
        // Remove if already exists to move to front
        updatedHistory.remove(promptId);
        updatedHistory.insert(0, promptId);

        // Keep only last 50 items
        if (updatedHistory.length > 50) {
          updatedHistory.removeRange(50, updatedHistory.length);
        }

        final updatedUser = currentUser.value!.copyWith(
          promptHistory: updatedHistory,
          totalPromptsGenerated: currentUser.value!.totalPromptsGenerated + 1,
        );
        await updateUser(updatedUser);
      } catch (e) {
        print('Error adding to history: $e');
      }
    }
  }

  Future<void> addFavoriteCategory(String category) async {
    if (currentUser.value != null) {
      try {
        final updatedCategories = [...currentUser.value!.favoriteCategories];
        if (!updatedCategories.contains(category)) {
          updatedCategories.add(category);
          final updatedUser = currentUser.value!.copyWith(
            favoriteCategories: updatedCategories,
          );
          await updateUser(updatedUser);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to add favorite category: $e');
      }
    }
  }

  Future<void> removeFavoriteCategory(String category) async {
    if (currentUser.value != null) {
      try {
        final updatedCategories = [...currentUser.value!.favoriteCategories];
        updatedCategories.remove(category);
        final updatedUser = currentUser.value!.copyWith(
          favoriteCategories: updatedCategories,
        );
        await updateUser(updatedUser);
      } catch (e) {
        Get.snackbar('Error', 'Failed to remove favorite category: $e');
      }
    }
  }

  bool isFavoritePrompt(String promptId) {
    return currentUser.value?.favoritePrompts.contains(promptId) ?? false;
  }

  bool isFavoriteCategory(String category) {
    return currentUser.value?.favoriteCategories.contains(category) ?? false;
  }

  void logout() {
    currentUser.value = null;
    isLoggedIn.value = false;
    _userService.logout();
  }
}
