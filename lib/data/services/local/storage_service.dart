import '../../models/entities/user.dart';

// A storage service contract [Usage: SharedPreferences]
abstract class StorageService {
  Future<bool> saveCurrentUser(User? user);

  Future<User?> getCurrentUser();

  Future<bool> saveAccessToken(String? accessToken);

  Future<String?> getAccessToken();

  bool isValidToken(User? user);

  Future<bool> clearStorageData();
}
