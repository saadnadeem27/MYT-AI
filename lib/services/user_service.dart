import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Dummy user data
  UserModel? _currentUser = UserModel(
    id: 'user_001',
    name: 'John Doe',
    email: 'john.doe@example.com',
    avatar: null,
    favoriteCategories: ['Writing', 'Art & Design', 'Coding'],
    favoritePrompts: ['2', '4', '6'],
    promptHistory: ['1', '3', '5', '7'],
    joinedAt: DateTime.now().subtract(const Duration(days: 30)),
    isPremium: false,
    totalPromptsGenerated: 47,
  );

  Future<UserModel?> getCurrentUser() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  Future<UserModel> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = user;
    return user;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate login - in real app, this would validate credentials
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = UserModel(
        id: 'user_001',
        name: 'John Doe',
        email: email,
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
        totalPromptsGenerated: 47,
      );
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate registration
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      _currentUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        joinedAt: DateTime.now(),
        totalPromptsGenerated: 0,
      );
      return true;
    }
    return false;
  }
}