import 'package:styla_mobile_app/core/domain/model/garment.dart';
import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/category.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/tag.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/color_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/style_option.dart';
import 'package:styla_mobile_app/features/wardrobe/domain/model/occasion_option.dart';

abstract class WardrobeState {}

class WardrobeIdleState extends WardrobeState {}

class WardrobeLoadingState extends WardrobeState {}

class WardrobeLoadedState extends WardrobeState {
  final List<Garment> garments;

  WardrobeLoadedState({required this.garments});
}

class WardrobeLoadedOneState extends WardrobeState {
  final Garment garment;

  WardrobeLoadedOneState({required this.garment});
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

class OutfitsLoadedState extends WardrobeState {
  final List<Outfit> outfits;

  OutfitsLoadedState({required this.outfits});
}

class WardrobeErrorState extends WardrobeState {
  final String message;

  WardrobeErrorState({required this.message});
}

class CategoriesLoadedState extends WardrobeState {
  final List<Category> categories;

  CategoriesLoadedState({required this.categories});
}

class TagsLoadedState extends WardrobeState {
  final List<Tag> tags;

  TagsLoadedState({required this.tags});
}

class ColorsLoadedState extends WardrobeState {
  final List<ColorOption> colors;

  ColorsLoadedState({required this.colors});
}

class StylesLoadedState extends WardrobeState {
  final List<StyleOption> styles;

  StylesLoadedState({required this.styles});
}

class OccasionsLoadedState extends WardrobeState {
  final List<OccasionOption> occasions;

  OccasionsLoadedState({required this.occasions});
}
