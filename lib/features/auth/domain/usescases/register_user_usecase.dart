import 'package:styla_mobile_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:styla_mobile_app/features/auth/domain/repository/auth_repository.dart';

class RegisterUserUsecase {
  final AuthRepository _authRepository = AuthRepositoryImpl();

  // SignupUserUsecase({required AuthRepository authRepository}) : _authRepository = authRepository; // Implementacion para inyección de dependencias

  Future<void> execute(String email, String password) async {
    await _authRepository.registerUser(email, password);
  }

}