class Movie {
  final int? id;
  final String title;
  final int year;
  final String plot;
  final String duration;
  final String photoPath;

  Movie({
    this.id,
    required this.title,
    required this.year,
    required this.plot,
    required this.duration,
    required this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'plot': plot,
      'duration': duration,
      'photo_path': photoPath,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      year: map['year'],
      plot: map['plot'],
      duration: map['duration'],
      photoPath: map['photo_path'],
    );
  }
}
