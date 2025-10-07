/// Modelo de dominio para el perfil de usuario
/// Entidad compartida en toda la aplicación
/// 
/// Representa la información personal y configuración del usuario
class Profile {
  /// UID de Supabase Auth
  final String id;
  
  final String nickname;
  
  /// URL completa de la foto de perfil desde Supabase Storage
  /// Ejemplo: 'https://xxx.supabase.co/storage/v1/object/public/avatars/user123.jpg'
  final String? photo;
  
  final String? phoneNumber;
  
  final int age;
  
  final bool isPrivate;
  
  /// Peso en kilogramos
  final double? weight;
  
  /// Altura en centímetros
  final double? height;
  
  final DateTime createdAt;
  
  final DateTime? updatedAt;

  const Profile({
    required this.id,
    required this.nickname,
    this.photo,
    this.phoneNumber,
    required this.age,
    this.isPrivate = false,
    this.weight,
    this.height,
    required this.createdAt,
    this.updatedAt,
  });

  factory Profile.empty() {
    return Profile(
      id: '',
      nickname: '',
      age: 0,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'photo': photo,
      'phone_number': phoneNumber,
      'age': age,
      'is_private': isPrivate,
      'weight': weight,
      'height': height,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      photo: json['photo'] as String?,
      phoneNumber: json['phone_number'] as String?,
      age: json['age'] as int,
      isPrivate: json['is_private'] as bool? ?? false,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Profile &&
        other.id == id &&
        other.nickname == nickname &&
        other.photo == photo &&
        other.phoneNumber == phoneNumber &&
        other.age == age &&
        other.isPrivate == isPrivate &&
        other.weight == weight &&
        other.height == height &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nickname.hashCode ^
        photo.hashCode ^
        phoneNumber.hashCode ^
        age.hashCode ^
        isPrivate.hashCode ^
        weight.hashCode ^
        height.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Profile(id: $id, nickname: $nickname, photo: $photo, phoneNumber: $phoneNumber, age: $age, isPrivate: $isPrivate, weight: $weight, height: $height)';
  }
}