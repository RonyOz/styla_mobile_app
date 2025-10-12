import 'package:styla_mobile_app/features/auth/domain/repository/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _authRepository;

  SignOutUsecase({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<void> execute() {
    return _authRepository.signOut();
  }
}
