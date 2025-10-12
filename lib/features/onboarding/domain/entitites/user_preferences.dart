class UserPreferences {
  final String style;
  final String preferredColor;
  final String preferredImage; // Almacenará la URL o un identificador de la imagen

  UserPreferences({
    required this.style,
    required this.preferredColor,
    required this.preferredImage,
  });
}