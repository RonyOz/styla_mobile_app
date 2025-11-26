import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/community/data/repository/community_repository_impl.dart';
import 'package:styla_mobile_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/get_profile_usecase.dart';
import 'package:styla_mobile_app/features/community/domain/usecases/get_random_outft_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetProfileUsecase _getProfileUsecase = GetProfileUsecase(
    profileRepository: ProfileRepositoryImpl(),
  );

  final GetRandomOutfitUseCase _getRandomOutfitUseCase = GetRandomOutfitUseCase(
    communityRepository: CommunityRepositoryImpl(),
  );

  DashboardBloc() : super(DashboardInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LoadRandomOutfitsRequested>(_onLoadRandomOutfitsRequested);
  }

  void _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final profile = await _getProfileUsecase.execute();
      emit(DashboardLoaded(profile: profile));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void _onLoadRandomOutfitsRequested(
    LoadRandomOutfitsRequested event,
    Emitter<DashboardState> emit,
  ) async {
    // No emitir DashboardLoading aquí para no sobrescribir el estado del perfil
    try {
      // Agregar timeout de 10 segundos
      final outfits = await _getRandomOutfitUseCase.execute().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout al cargar outfits');
        },
      );
      print("Outfits loaded: $outfits");
      emit(OutfitsLoadedState(outfits: outfits));
    } catch (e) {
      print("Error loading outfits: $e");
      emit(DashboardError(e.toString()));
    }
  }
}
