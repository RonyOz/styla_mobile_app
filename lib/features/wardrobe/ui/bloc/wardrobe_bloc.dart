import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';

import 'package:styla_mobile_app/features/wardrobe/domain/usecases/usecases.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

import 'package:styla_mobile_app/features/wardrobe/data/repository/wardrobe_repository_impl.dart';

class WardrobeBloc extends Bloc<WardrobeEvent, WardrobeState> {
  final WardrobeRepository _wardrobeRepository;
  late final GetAvailableCategoriesUsecase _getAvailableCategoriesUsecase;
  late final AddGarmentUsecase _addGarmentUsecase;
  late final GetAvailableTagsUsecase _getAvailableTagsUsecase;
  late final GetGarmentsUsecase _getGarmentsUsecase;
  late final DeleteGarmentUsecase _deleteGarmentUsecase;
  late final UpdateGarmentUsecase _updateGarmentUsecase;

  WardrobeBloc({WardrobeRepository? wardrobeRepository})
    : _wardrobeRepository = wardrobeRepository ?? WardrobeRepositoryImpl(),
      super(WardrobeIdleState()) {
    _addGarmentUsecase = AddGarmentUsecase(wardrobeRepository: _wardrobeRepository);
    _getAvailableCategoriesUsecase = GetAvailableCategoriesUsecase(wardrobeRepository: _wardrobeRepository);
    _getAvailableTagsUsecase = GetAvailableTagsUsecase(wardrobeRepository: _wardrobeRepository);
    _getGarmentsUsecase = GetGarmentsUsecase(wardrobeRepository: _wardrobeRepository);
    _deleteGarmentUsecase = DeleteGarmentUsecase(wardrobeRepository: _wardrobeRepository);
    _updateGarmentUsecase = UpdateGarmentUsecase(wardrobeRepository: _wardrobeRepository);

    on<AddGarmentRequested>(_onAddGarmentRequested);
    on<LoadGarmentsRequested>(_onLoadGarmentsRequested);
    on<DeleteGarmentRequested>(_onDeleteGarmentRequested);
    on<UpdateGarmentRequested>(_onUpdateGarmentRequested);
    on<LoadCategoriesRequested>(_onLoadCategoriesRequested);
    on<LoadTagsRequested>(_onLoadTagsRequested);
  }

  Future<void> _onAddGarmentRequested(
    AddGarmentRequested event,
    Emitter<WardrobeState> emit,
  ) async {
    emit(WardrobeLoadingState());
    try {
      final garment = await _addGarmentUsecase.execute(
        imagePath: event.imagePath,
        categoryId: event.categoryId,
        tagIds: event.tagIds,
        color: event.color,
        style: event.style,
        occasion: event.occasion,
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
      final garments = await _getGarmentsUsecase.execute();
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
      await _deleteGarmentUsecase.execute(garmentId: event.garmentId);
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
      final garment = await _updateGarmentUsecase.execute(
        garment: event.garment,
      );
      emit(GarmentUpdatedState(garment: garment));
    } catch (e) {
      emit(WardrobeErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadCategoriesRequested(
    LoadCategoriesRequested event,
    Emitter<WardrobeState> emit,
  ) async {
    try {
      final categories = await _getAvailableCategoriesUsecase.execute();
      emit(CategoriesLoadedState(categories: categories));
    } catch (e) {
      emit(WardrobeErrorState(message: e.toString()));
    }
  }

  Future<void> _onLoadTagsRequested(
    LoadTagsRequested event,
    Emitter<WardrobeState> emit,
  ) async {
    try {
      final tags = await _getAvailableTagsUsecase.execute();
      emit(TagsLoadedState(tags: tags));
    } catch (e) {
      emit(WardrobeErrorState(message: e.toString()));
    }
  }
}
