class UserProfile {
  final String userId;
  final String? nickname;
  final String? photo;
  final String? gender;
  final int? age;

  UserProfile({
    required this.userId,
    this.nickname,
    this.photo,
    this.gender,
    this.age,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String?,
      photo: json['photo'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
    );
  }
}
