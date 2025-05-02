class NewConcept {
  final String id;
  final String name;
  final String logo;

  NewConcept({required this.id, required this.name, required this.logo});

  factory NewConcept.fromJson(Map<String, dynamic> json) {
    return NewConcept(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
