class Preferences {
  final String name;

  const Preferences({required this.name});

  const Preferences.empty() : name = '';

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(name: json['name'] as String);
  }

  Preferences copyWith({String? name}) {
    return Preferences(name: name ?? this.name);
  }

  @override
  String toString() {
    return 'Preferences(name: $name)';
  }
}
