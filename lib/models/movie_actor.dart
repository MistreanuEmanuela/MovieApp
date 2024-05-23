class MovieActor {
  final int? id;
  final int idMovie;
  final int idActor;
  final int idRole;

  MovieActor({
    this.id,
    required this.idMovie,
    required this.idActor,
    required this.idRole,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_movie': idMovie,
      'id_actor': idActor,
      'id_role': idRole,
    };
  }

  factory MovieActor.fromMap(Map<String, dynamic> map) {
    return MovieActor(
      id: map['id'],
      idMovie: map['id_movie'],
      idActor: map['id_actor'],
      idRole: map['id_role'],
    );
  }
}