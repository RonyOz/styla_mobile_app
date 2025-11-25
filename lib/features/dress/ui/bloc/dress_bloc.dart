import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/dress/data/repository/dress_repository_impl.dart';
import 'package:styla_mobile_app/features/dress/domain/repository/dress_repository.dart';
import 'package:styla_mobile_app/features/dress/domain/usecase/add_outfit_usecase.dart';
import 'package:styla_mobile_app/features/dress/domain/usecase/get_outfits_usecase.dart';
import 'package:styla_mobile_app/features/dress/ui/bloc/events/dress_event.dart';
import 'package:styla_mobile_app/features/dress/ui/bloc/states/dress_state.dart';

class DressBloc extends Bloc<DressEvent, DressState> {
  late final AddOutfitUsecase _addOutfitUsecase;
  late final GetOutfitsUseCase _getOutfitsUseCase;
  final DressRepository _dressRepository;

  DressBloc({required DressRepository dressRepository})
    : _dressRepository = dressRepository,
      super(DressIdleState()) {
    _addOutfitUsecase = AddOutfitUsecase(dressRepository: _dressRepository);
    _getOutfitsUseCase = GetOutfitsUseCase(dressRepository: _dressRepository);

    // Registrar manejadores de eventos
    on<SaveDressDataRequested>(_addOutfit);
    on<LoadDressDataRequested>(_loadOutfits);
    on<DeleteDressDataRequested>(_deleteOutfit);
    on<DressErrorOccurred>(_handleError);
    on<LoadGarmentsDataRequested>(_loadGarments);
  }

  Future<void> _addOutfit(
    SaveDressDataRequested event,
    Emitter<DressState> emit,
  ) async {
    emit(DressLoadingState());
    try {
      await _addOutfitUsecase.execute(
        name: event.name,
        description: event.description,
        promptId: event.promptId,
        shirt: event.shirt,
        pants: event.pants,
        shoes: event.shoes,
      );
      emit(DressSavedState());
    } catch (e) {
      emit(DressErrorState(message: e.toString()));
    }
  }

  Future<void> _loadOutfits(
    LoadDressDataRequested event,
    Emitter<DressState> emit,
  ) async {
    emit(DressLoadingState());
    try {
      final outfits = await _getOutfitsUseCase.execute();
      print("Aquiiii leggooo el outfitssss: $outfits");
      emit(DressDataLoadedState(outfits: outfits));
    } catch (e) {
      emit(DressErrorState(message: e.toString()));
    }
  }

  Future<void> _deleteOutfit(
    DeleteDressDataRequested event,
    Emitter<DressState> emit,
  ) async {
    emit(DressLoadingState());
    try {
      // Implementar lógica de eliminación
      emit(DressDeletedState());
    } catch (e) {
      emit(DressErrorState(message: e.toString()));
    }
  }

  Future<void> _loadGarments(
    LoadGarmentsDataRequested event,
    Emitter<DressState> emit,
  ) async {
    emit(DressLoadingState());
    try {
      final garments = await _dressRepository.loadGarmentsData();
      //print("Aquiiii leggooo las prendas: $garments");
      emit(GarmentsDataLoadedState(garments: garments));
    } catch (e) {
      emit(DressErrorState(message: e.toString()));
    }
  }

  Future<void> _handleError(
    DressErrorOccurred event,
    Emitter<DressState> emit,
  ) async {
    emit(DressErrorState(message: event.message));
  }
}
