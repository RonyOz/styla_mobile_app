class Users {
  String user_id;
  String email;
  String password;
  String settings_setting_id;

  Users({
    required this.user_id,
    required this.email,
    required this.password,
    required this.settings_setting_id,
  });

  factory Users.empty() {
    return Users(user_id: '', email: '', password: '', settings_setting_id: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'email': email,
      'password': password,
      'settings_setting_id': settings_setting_id,
    };
  }

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      user_id: json['user_id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      settings_setting_id: json['settings_setting_id'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Users &&
        other.user_id == user_id &&
        other.email == email &&
        other.password == password &&
        other.settings_setting_id == settings_setting_id;
  }

  @override
  int get hashCode =>
      user_id.hashCode ^
      email.hashCode ^
      password.hashCode ^
      settings_setting_id.hashCode;

  @override
  String toString() =>
      'User(user_id: $user_id, email: $email, password: $password, settings_setting_id: $settings_setting_id)';
}
