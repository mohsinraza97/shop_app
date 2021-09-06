import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/utilities/json_utils.dart';
import '../../models/entities/user.dart';

class StorageClient {
  const StorageClient._internal();

  static final StorageClient _instance = StorageClient._internal();

  static StorageClient get instance => _instance;

  Future<bool> saveUser(User? user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final value = JsonUtils.toJson(user?.toJson()) ?? '';
    return await pref.setString(AppConstants.pref_user, value);
  }

  Future<User?> getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(AppConstants.pref_user)) {
      final value = pref.getString(AppConstants.pref_user);
      final hasValue = value?.isNotEmpty ?? false;
      return hasValue ? User.fromJson(JsonUtils.fromJson(value)) : null;
    }
    return null;
  }

  Future<bool> saveAccessToken(String? accessToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final value = accessToken ?? '';
    return await pref.setString(AppConstants.pref_access_token, value);
  }

  Future<String?> getAccessToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey(AppConstants.pref_access_token)) {
      return pref.getString(AppConstants.pref_access_token);
    }
    return null;
  }

  Future<bool> clear() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.clear();
  }
}
