import 'package:styla_mobile_app/features/auth/data/source/auth_data_source.dart';
import 'package:styla_mobile_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthDataSource _authDataSource = AuthDataSourceImpl();
  
  @override
  Future<void> registerUser(String email, String password) async {}

  Future<void> signIn(String email, String password) {
    return _authDataSource.signIn(email, password);
  }
  
  @override
  Future<void> signOut() {
    return _authDataSource.signOut();
  }
}
