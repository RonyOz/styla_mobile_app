import 'package:styla_mobile_app/core/domain/model/profile.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final Profile profile;

  DashboardLoaded(this.profile);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
