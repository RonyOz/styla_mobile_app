import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/auth/domain/usescases/register_user_usecase.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/events/signup_event.dart';
import 'package:styla_mobile_app/features/auth/ui/bloc/states/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final RegisterUserUsecase _registerUserUsecase = RegisterUserUsecase();

  SignupBloc() : super(SignupIdleState()) {
    on<SignupRequested>(_registerUser);
  }

  void _registerUser(SignupRequested event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());

    try {
      await _registerUserUsecase.execute(event.email, event.password);
      emit(SignupSuccessState());
    } catch (e) {
      emit(SignupErrorState(e.toString()));
    }
  }
}
