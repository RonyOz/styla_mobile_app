abstract class SignupEvent {}

class SignupRequested extends SignupEvent {
  final String email;
  final String password;

  SignupRequested({required this.email, required this.password});
}
