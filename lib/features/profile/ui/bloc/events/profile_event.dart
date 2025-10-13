abstract class ProfileEvent {}

/// Le dice al BLoC que cargue los datos del perfil del usuario actual.
class LoadProfile extends ProfileEvent {}

/// Le indica a la UI que debe mostrar la confirmación de cierre de sesión.
class SignOutRequested extends ProfileEvent {}

/// Confirma que el usuario realmente quiere cerrar sesión (despachado desde el diálogo).
class SignOutConfirmed extends ProfileEvent {}