import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:styla_mobile_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/get_profile_usecase.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/sign_out_usecase.dart';
import 'package:styla_mobile_app/features/profile/ui/bloc/events/profile_event.dart';
import 'package:styla_mobile_app/features/profile/ui/bloc/states/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase _getProfileUsecase =
      GetProfileUsecase(profileRepository: ProfileRepositoryImpl());
  final SignOutUsecase _signOutUsecase =
      SignOutUsecase(authRepository: AuthRepositoryImpl());

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<SignOutRequested>(_onSignOutRequested);
    on<SignOutConfirmed>(_onSignOutConfirmed);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final profile = await _getProfileUsecase.execute();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void _onSignOutRequested(SignOutRequested event, Emitter<ProfileState> emit) {
    // Simplemente emitimos el estado de confirmación. La UI se encargará de mostrar el widget.
    emit(ProfileLogoutConfirmation());
  }
  
  void _onSignOutConfirmed(SignOutConfirmed event, Emitter<ProfileState> emit) async {
    try {
      await _signOutUsecase.execute();
      emit(ProfileSignedOut());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}