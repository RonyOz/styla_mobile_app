class Users {
  String user_id;
  String email;
  String password;

  Users({required this.user_id, required this.email, required this.password});

  factory Users.empty() {
    return Users(user_id: '', email: '', password: '');
  }

  Map<String, dynamic> toJson() {
    return {'user_id': user_id, 'email': email, 'password': password};
  }

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      user_id: json['user_id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Users &&
        other.user_id == user_id &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => user_id.hashCode ^ email.hashCode ^ password.hashCode;

  @override
  String toString() =>
      'User(user_id: $user_id, email: $email, password: $password)';
}
