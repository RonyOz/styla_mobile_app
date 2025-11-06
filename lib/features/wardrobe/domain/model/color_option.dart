class ColorOption {
  final String id;
  final String name;

  ColorOption({required this.id, required this.name});

  factory ColorOption.fromJson(Map<String, dynamic> json) {
    return ColorOption(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
