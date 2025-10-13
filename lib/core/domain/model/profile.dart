/// Modelo de dominio para el perfil de usuario
/// Entidad compartida en toda la aplicación
///
/// Representa la información personal y configuración del usuario
class Profile {
  /// UID de Supabase Auth
  String id;

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

  final String? gender;

  DateTime? birthdate;

  final DateTime createdAt;

  final DateTime? updatedAt;

  Profile({
    required this.id,
    required this.nickname,
    this.photo,
    this.phoneNumber,
    required this.age,
    this.isPrivate = false,
    this.weight,
    this.height,
    this.gender,
    this.birthdate,
    required this.createdAt,
    this.updatedAt,
  });

  factory Profile.empty() {
    return Profile(id: '', nickname: '', age: 0, createdAt: DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'nickname': nickname,
      'photo': photo,
      'age': age,
      'telephonenumber': phoneNumber,
      'birthdate': birthdate?.toIso8601String(),
      'isprivate': isPrivate,
      'weight': weight,
      'height': height,
      'gender': gender,
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
      gender: json['gender'] as String?,
      birthdate: json['birthdate'] != null
          ? DateTime.parse(json['birthdate'] as String)
          : null,
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
        other.gender == gender &&
        other.birthdate == birthdate &&
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
        gender.hashCode ^
        birthdate.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'Profile(id: $id, nickname: $nickname, photo: $photo, phoneNumber: $phoneNumber, age: $age, isPrivate: $isPrivate, weight: $weight, height: $height, gender: $gender, Birthdate: $birthdate)';
  }

  Profile copyWith({
    String? id,
    String? nickname,
    String? photo,
    String? phoneNumber,
    int? age,
    bool? isPrivate,
    double? weight,
    double? height,
    String? gender,
    DateTime? birthdate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      photo: photo ?? this.photo,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      isPrivate: isPrivate ?? this.isPrivate,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
