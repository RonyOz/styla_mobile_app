import 'package:styla_mobile_app/core/domain/model/profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

/// Un estado específico para señalar a la UI que debe mostrar el diálogo de confirmación.
class ProfileLogoutConfirmation extends ProfileState {}

/// Estado final que indica que el usuario ha cerrado sesión y se debe navegar al login.
class ProfileSignedOut extends ProfileState {}