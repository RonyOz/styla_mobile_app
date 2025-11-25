import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';

abstract class DressState {}

class DressIdleState extends DressState {}

class DressLoadingState extends DressState {}

class DressSavedState extends DressState {}

class DressDeletedState extends DressState {}

class DressErrorState extends DressState {
  final String message;

  DressErrorState({required this.message});
}

class DressDataLoadedState extends DressState {
  final List<Outfit> outfits;

  DressDataLoadedState({required this.outfits});
}

class GarmentsDataLoadedState extends DressState {
  final List<Garment> garments;

  GarmentsDataLoadedState({required this.garments});
}
