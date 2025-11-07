class StyleOption {
  final String id;
  final String name;

  StyleOption({required this.id, required this.name});

  factory StyleOption.fromJson(Map<String, dynamic> json) {
    return StyleOption(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
