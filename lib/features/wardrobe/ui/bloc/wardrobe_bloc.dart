import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/usecases/add_garment_usecase.dart';
import 'package:styla_mobile_app/features/wardrobe/data/repository/wardrobe_repository_impl.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';

class WardrobeBloc extends Bloc<WardrobeEvent, WardrobeState> {
  final WardrobeRepository _wardrobeRepository;
  late final AddGarmentUsecase _addGarmentUsecase;

  WardrobeBloc({WardrobeRepository? wardrobeRepository})
      : _wardrobeRepository = wardrobeRepository ?? WardrobeRepositoryImpl(),
        super(WardrobeIdleState()) {
    _addGarmentUsecase = AddGarmentUsecase(wardrobeRepository: _wardrobeRepository);

    on<AddGarmentRequested>(_onAddGarmentRequested);
    on<LoadGarmentsRequested>(_onLoadGarmentsRequested);
    on<DeleteGarmentRequested>(_onDeleteGarmentRequested);
    on<UpdateGarmentRequested>(_onUpdateGarmentRequested);
  }

  Future<void> _onAddGarmentRequested(
    AddGarmentRequested event,
    Emitter<WardrobeState> emit,
  ) async {
    emit(WardrobeLoadingState());
    try {
      final garment = await _addGarmentUsecase.execute(
        imagePath: event.imagePath,
        category: event.category,
      );
      emit(GarmentAddedState(garment: garment));
    } catch (e) {
      emit(WardrobeErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadGarmentsRequested(
    LoadGarmentsRequested event,
    Emitter<WardrobeState> emit,
  ) async {
    emit(WardrobeLoadingState());
    try {
      final garments = await _wardrobeRepository.getGarments();
      emit(WardrobeLoadedState(garments: garments));
    } catch (e) {
      emit(WardrobeErrorState(message: e.toString()));
    }
  }

  Future<void> _onDeleteGarmentRequested(
    DeleteGarmentRequested event,
    Emitter<WardrobeState> emit,
  ) async {
    emit(WardrobeLoadingState());
    try {
      await _wardrobeRepository.deleteGarment(event.garmentId);
      emit(GarmentDeletedState(garmentId: event.garmentId));
    } catch (e) {
      emit(WardrobeErrorState(message: e.toString()));
    }
  }

  Future<void> _onUpdateGarmentRequested(
    UpdateGarmentRequested event,
    Emitter<WardrobeState> emit,
  ) async {
    emit(WardrobeLoadingState());
    try {
      final garment = await _wardrobeRepository.updateGarment(event.garment);
      emit(GarmentUpdatedState(garment: garment));
    } catch (e) {
      emit(WardrobeErrorState(message: e.toString()));
    }
  }
}
