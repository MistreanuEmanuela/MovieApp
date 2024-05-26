class Actor {
  final int? id;
  final String name;
  final String bio;
  final String photoPath;
  final String birthdate;
  final String bibliography;

  Actor({
    this.id,
    required this.name,
    required this.bio,
    required this.photoPath,
    required this.birthdate,
    required this.bibliography,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'photo_path': photoPath,
      'birthdate': birthdate,
      'bibliography': bibliography,
    };
  }

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'],
      name: map['name'] ?? '',
      bio: map['bio'] ?? '',
      photoPath: map['photo_path'] ?? '',
      birthdate: map['birthdate'] ?? '',
      bibliography: map['bibliography'] ?? '',
    );
  }
}
