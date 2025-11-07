class OccasionOption {
  final String id;
  final String name;

  OccasionOption({required this.id, required this.name});

  factory OccasionOption.fromJson(Map<String, dynamic> json) {
    return OccasionOption(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
