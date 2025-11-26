abstract class DressEvent {}

class SaveDressDataRequested extends DressEvent {
  final String name;
  final String description;
  final String promptId;
  final String shirt;
  final String pants;
  final String? shoes;

  SaveDressDataRequested({
    required this.name,
    required this.description,
    required this.promptId,
    required this.shirt,
    required this.pants,
    this.shoes,
  });
}

class LoadDressDataRequested extends DressEvent {}

class DeleteDressDataRequested extends DressEvent {
  final String outfitId;

  DeleteDressDataRequested({required this.outfitId});
}

class DressErrorOccurred extends DressEvent {
  final String message;

  DressErrorOccurred({required this.message});
}

class LoadGarmentsDataRequested extends DressEvent {}

class DressDataLoaded extends DressEvent {
  final List outfits;

  DressDataLoaded({required this.outfits});
}

class GarmentsDataLoaded extends DressEvent {
  final List garments;

  GarmentsDataLoaded({required this.garments});
}
