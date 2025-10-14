class Profile {
  String id;
  final String nickname;
  final String? photo;
  final String? phoneNumber;
  final int age;
  final bool isPrivate;
  final double? weight;
  final double? height;
  final String? gender;
  DateTime? birthdate;

  // FIX: Removed createdAt and updatedAt as they are not in the DB schema
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
  });

  factory Profile.empty() {
    return Profile(id: '', nickname: '', age: 0);
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

  // =================== CORRECTED FROMJSON ===================
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      // FIX: Use 'user_id' to match the database column name
      id: json['user_id'] as String,
      nickname: json['nickname'] as String,
      photo: json['photo'] as String?,
      // FIX: Use 'telephonenumber' to match the database column name
      phoneNumber: json['telephonenumber'] as String?,
      // FIX: Safely handle nullable numeric type from DB
      age: (json['age'] as num?)?.toInt() ?? 0,
      // FIX: Use 'isprivate' to match the database column name
      isPrivate: json['isprivate'] as bool? ?? false,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      gender: json['gender'] as String?,
      birthdate: json['birthdate'] != null
          ? DateTime.parse(json['birthdate'] as String)
          : null,
      // FIX: Removed createdAt and updatedAt because they don't exist in the 'profiles' table.
      // This was the primary cause of the crash.
    );
  }
  // ==========================================================

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
        other.birthdate == birthdate;
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
        birthdate.hashCode;
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
    );
  }
}