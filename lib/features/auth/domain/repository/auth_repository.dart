abstract class AuthRepository {
  Future<void> registerUser(String email, String password) async {}
  Future<void> signIn(String email, String password);
}
