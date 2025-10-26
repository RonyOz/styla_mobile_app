import 'package:styla_mobile_app/core/domain/model/garment.dart';

abstract class WardrobeState {}

class WardrobeIdleState extends WardrobeState {}

class WardrobeLoadingState extends WardrobeState {}

class WardrobeLoadedState extends WardrobeState {
  final List<Garment> garments;

  WardrobeLoadedState({required this.garments});
}

class GarmentAddedState extends WardrobeState {
  final Garment garment;

  GarmentAddedState({required this.garment});
}

class GarmentDeletedState extends WardrobeState {
  final String garmentId;

  GarmentDeletedState({required this.garmentId});
}

class GarmentUpdatedState extends WardrobeState {
  final Garment garment;

  GarmentUpdatedState({required this.garment});
}

class WardrobeErrorState extends WardrobeState {
  final String message;

  WardrobeErrorState({required this.message});
}
