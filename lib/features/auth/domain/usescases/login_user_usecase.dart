import 'package:styla_mobile_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:styla_mobile_app/features/auth/domain/repository/auth_repository.dart';

class LoginUserUsecase {
  final AuthRepository _authRepository = AuthRepositoryImpl();

  Future<void> execute(String email, String password) {
    return _authRepository.signIn(email, password);
  }
}
