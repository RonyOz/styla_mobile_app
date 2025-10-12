
abstract class SignupState {}

class SignupIdleState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {}

class SignupErrorState extends SignupState {
  final String message;
  SignupErrorState(this.message);
}
