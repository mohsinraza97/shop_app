import '../../../data/services/local/storage_service.dart';
import '../../../data/models/ui/ui_response.dart';
import '../../resources/app_strings.dart';
import '../../../data/models/entities/user.dart';
import '../../../data/app_locator.dart';
import '../../../data/services/entities/auth_service.dart';
import '../base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _storageService = locator<StorageService>();
  User? _user;

  User? get user => _user;

  Future<UiResponse<bool>> signUp(UserRequest? userRequest) async {
    final response = await _authService.signUp(userRequest);
    return _handleAuthResponse(response);
  }

  Future<UiResponse<bool>> login(UserRequest? userRequest) async {
    final response = await _authService.login(userRequest);
    return _handleAuthResponse(response);
  }

  Future<User?> getAuthenticatedUser() async {
    _user = await _authService.getAuthenticatedUser();
    return _user;
  }

  Future<void> logout() async {
    await _setUserData(null);
  }

  Future<void> _setUserData(User? user) async {
    _user = user;
    await _storageService.saveCurrentUser(user);
    await _storageService.saveAccessToken(user?.token);
    notifyListeners();
  }

  Future<UiResponse<bool>> _handleAuthResponse(
    UiResponse<User> response,
  ) async {
    if (response.hasData) {
      await _setUserData(response.data);
      return UiResponse(data: true);
    }
    return UiResponse(
      errorMessage: response.errorMessage ?? AppStrings.error_ui_general,
    );
  }
}
