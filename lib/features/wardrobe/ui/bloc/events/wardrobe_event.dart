import 'package:styla_mobile_app/core/domain/model/garment.dart';

abstract class WardrobeEvent {}

class AddGarmentRequested extends WardrobeEvent {
  final String imagePath;
  final String category;

  AddGarmentRequested({
    required this.imagePath,
    required this.category,
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
