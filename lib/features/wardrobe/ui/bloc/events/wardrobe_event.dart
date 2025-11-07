import 'package:styla_mobile_app/core/domain/model/garment.dart';

abstract class WardrobeEvent {}

class AddGarmentRequested extends WardrobeEvent {
  final String imagePath;
  final String categoryId;
  final List<String> tagIds;
  final String color;
  final String style;
  final String occasion;

  AddGarmentRequested({
    required this.imagePath,
    required this.categoryId,
    required this.color,
    required this.style,
    required this.occasion,
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

class LoadCategoriesRequested extends WardrobeEvent {}

class LoadTagsRequested extends WardrobeEvent {}

class GetFilteredGarmentsRequested extends WardrobeEvent {
  final String? category;
  final List<String>? tags;

  GetFilteredGarmentsRequested({this.category, this.tags});
}

class UpdateGarmentImageRequested extends WardrobeEvent {
  final String garmentId;
  final String newImagePath;

  UpdateGarmentImageRequested({
    required this.garmentId,
    required this.newImagePath,
  });
}

class UpdateGarmentCategoryRequested extends WardrobeEvent {
  final String garmentId;
  final String categoryId;

  UpdateGarmentCategoryRequested({
    required this.garmentId,
    required this.categoryId,
  });
}

class GetGarmentByIdRequested extends WardrobeEvent {
  final String garmentId;

  GetGarmentByIdRequested({required this.garmentId});
}
