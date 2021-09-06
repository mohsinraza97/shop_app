import '../../models/entities/user.dart';
import '../../models/ui/ui_response.dart';

abstract class AuthService {
  Future<UiResponse<User>> signUp(UserRequest? userRequest);

  Future<UiResponse<User>> login(UserRequest? userRequest);

  Future<User?> getAuthenticatedUser();
}
