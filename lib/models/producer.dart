class Producer {
  final int? id;
  final String name;
  final String bio;
  final String photoPath;

  Producer({
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

  factory Producer.fromMap(Map<String, dynamic> map) {
    return Producer(
      id: map['id'],
      name: map['name'],
      bio: map['bio'],
      photoPath: map['photo_path'],
    );
  }
}