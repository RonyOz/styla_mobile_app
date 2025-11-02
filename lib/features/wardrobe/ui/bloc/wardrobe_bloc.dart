import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:styla_mobile_app/features/wardrobe/ui/bloc/events/wardrobe_event.dart';
import 'package:styla_mobile_app/features/wardrobe/ui/bloc/states/wardrobe_state.dart';

import 'package:styla_mobile_app/features/wardrobe/domain/usecases/usecases.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/repository/wardrobe_repository.dart';

import 'package:styla_mobile_app/features/wardrobe/data/repository/wardrobe_repository_impl.dart';

import 'package:styla_mobile_app/features/profile/domain/repository/profile_repository.dart';
import 'package:styla_mobile_app/features/profile/data/repository/profile_repository_impl.dart';
import 'package:styla_mobile_app/features/profile/domain/usescases/who_am_i_usecase.dart';

class WardrobeBloc extends Bloc<WardrobeEvent, WardrobeState> {
  final WardrobeRepository _wardrobeRepository;
  final ProfileRepository _profileRepository;
  late final GetAvailableCategoriesUsecase _getAvailableCategoriesUsecase;
  late final AddGarmentUsecase _addGarmentUsecase;
  late final GetAvailableTagsUsecase _getAvailableTagsUsecase;
  late final GetGarmentsUsecase _getGarmentsUsecase;
  late final DeleteGarmentUsecase _deleteGarmentUsecase;
  late final UpdateGarmentUsecase _updateGarmentUsecase;
  late final WhoAmIUsecase _whoAmIUsecase;

  WardrobeBloc({
    WardrobeRepository? wardrobeRepository,
    ProfileRepository? profileRepository,
  }) : _wardrobeRepository = wardrobeRepository ?? WardrobeRepositoryImpl(),
       _profileRepository = profileRepository ?? ProfileRepositoryImpl(),
       super(WardrobeIdleState()) {
    _addGarmentUsecase = AddGarmentUsecase(wardrobeRepository: _wardrobeRepository);
    _getAvailableCategoriesUsecase = GetAvailableCategoriesUsecase(wardrobeRepository: _wardrobeRepository);
    _getAvailableTagsUsecase = GetAvailableTagsUsecase(wardrobeRepository: _wardrobeRepository);
    _getGarmentsUsecase = GetGarmentsUsecase(wardrobeRepository: _wardrobeRepository);
    _deleteGarmentUsecase = DeleteGarmentUsecase(wardrobeRepository: _wardrobeRepository);
    _updateGarmentUsecase = UpdateGarmentUsecase(wardrobeRepository: _wardrobeRepository);
    _whoAmIUsecase = WhoAmIUsecase(profileRepository: _profileRepository);

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
      // Obtener userId del usuario autenticado
      final userId = _whoAmIUsecase.execute();
      
      final garment = await _addGarmentUsecase.execute(
        imagePath: event.imagePath,
        categoryId: event.categoryId,
        tagIds: event.tagIds,
        color: event.color,
        style: event.style,
        occasion: event.occasion,
        userId: userId,
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
