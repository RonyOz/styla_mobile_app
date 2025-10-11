import 'package:styla_mobile_app/features/auth/domain/repository/auth_repository.dart';

class SignupUserUsecase {
  final AuthRepository _authRepository;

  SignupUserUsecase({required AuthRepository authRepository}) : _authRepository = authRepository;

  Future<void> execute(String email, String password) async {
    await _authRepository.registerUser(email, password);
  }

}