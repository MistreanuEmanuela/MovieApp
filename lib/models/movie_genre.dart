class GenreMovie {
  final int? id;
  final int idMovie;
  final int idGenre;

  GenreMovie({
    this.id,
    required this.idMovie,
    required this.idGenre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_movie': idMovie,
      'id_genre': idGenre,
    };
  }

  factory GenreMovie.fromMap(Map<String, dynamic> map) {
    return GenreMovie(
      id: map['id'],
      idMovie: map['id_movie'],
      idGenre: map['id_genre'],
    );
  }
}