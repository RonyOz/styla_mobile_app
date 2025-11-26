import 'package:styla_mobile_app/core/domain/model/outfit.dart';
import 'package:styla_mobile_app/core/domain/model/profile.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final Profile profile;
  final List<Outfit> outfits;
  final bool outfitsLoading;

  DashboardLoaded({
    required this.profile,
    this.outfits = const [],
    this.outfitsLoading = false,
  });

  DashboardLoaded copyWith({
    Profile? profile,
    List<Outfit>? outfits,
    bool? outfitsLoading,
  }) {
    return DashboardLoaded(
      profile: profile ?? this.profile,
      outfits: outfits ?? this.outfits,
      outfitsLoading: outfitsLoading ?? this.outfitsLoading,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}

class OutfitsLoadedState extends DashboardState {
  final List<Outfit> outfits;

  OutfitsLoadedState({required this.outfits});
}
