class Role {
  final int? id;
  final String name;

  Role({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      id: map['id'],
      name: map['name'],
    );
  }
}