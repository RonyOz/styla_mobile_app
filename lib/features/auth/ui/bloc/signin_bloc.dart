import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/auth/domain/usescases/login_user_usecase.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/events/signIn_event.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/states/signIn_state.dart';

class SigninBloc extends Bloc<SignInEvent, SignInState> {
  final LoginUserUsecase _loginUserUsecase = LoginUserUsecase();
  SigninBloc() : super(SignInIdleState()) {
    on<SignInRequested>(_loginUser);
  }

  void _loginUser(SignInRequested event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState());
    try {
      await _loginUserUsecase.execute(event.email, event.password);
      emit(SignInSuccessState());
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }
}
