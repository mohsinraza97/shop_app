import '../../../ui/resources/app_strings.dart';
import '../../models/entities/user.dart';
import '../../models/ui/ui_response.dart';
import '../base_repository.dart';
import '../../services/entities/auth_service.dart';

class AuthRepository extends BaseRepository implements AuthService {
  @override
  Future<UiResponse<User>> signUp(UserRequest? userRequest) async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.signUp(userRequest);
    return UiResponse.map(response);
  }

  @override
  Future<UiResponse<User>> login(UserRequest? userRequest) async {
    if (!await hasInternet()) {
      return UiResponse(
        errorMessage: AppStrings.error_internet_unavailable,
      );
    }
    final response = await networkService.login(userRequest);
    return UiResponse.map(response);
  }

  @override
  Future<User?> getAuthenticatedUser() async {
    // Two checks: Token stored and not expired
    final user = await storageService.getCurrentUser();
    return storageService.isValidToken(user) ? user : null;
  }
}
