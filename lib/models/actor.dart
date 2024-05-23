class Actor {
  final int? id;
  final String name;
  final String bio;
  final String photoPath;

  Actor({
    this.id,
    required this.name,
    required this.bio,
    required this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'photo_path': photoPath,
    };
  }
}