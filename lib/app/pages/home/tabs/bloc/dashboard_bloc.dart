import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/get_profile_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetProfileUsecase _getProfileUsecase = GetProfileUsecase(
    profileRepository: ProfileRepositoryImpl(),
  );

  DashboardBloc() : super(DashboardInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
  }

  void _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final profile = await _getProfileUsecase.execute();
      emit(DashboardLoaded(profile));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
