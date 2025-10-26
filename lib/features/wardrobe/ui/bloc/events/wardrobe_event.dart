import 'package:styla_mobile_app/core/domain/model/garment.dart';

abstract class WardrobeEvent {}

class AddGarmentRequested extends WardrobeEvent {
  final String imagePath;
  final String categoryId;
  final List<String> tagIds;

  AddGarmentRequested({
    required this.imagePath,
    required this.categoryId,
    this.tagIds = const [],
  });
}

class LoadGarmentsRequested extends WardrobeEvent {}

class DeleteGarmentRequested extends WardrobeEvent {
  final String garmentId;

  DeleteGarmentRequested({required this.garmentId});
}

class UpdateGarmentRequested extends WardrobeEvent {
  final Garment garment;

  UpdateGarmentRequested({required this.garment});
}
