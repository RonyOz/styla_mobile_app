abstract class SignInState {}

class SignInIdleState extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {}

class SignInErrorState extends SignInState {
  final String message;
  SignInErrorState(this.message);
}
