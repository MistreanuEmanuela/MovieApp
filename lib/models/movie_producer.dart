class MovieProducer {
  final int? id;
  final int idMovie;
  final int idProducer;

  MovieProducer({
    this.id,
    required this.idMovie,
    required this.idProducer,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_movie': idMovie,
      'id_producer': idProducer,
    };
  }

  factory MovieProducer.fromMap(Map<String, dynamic> map) {
    return MovieProducer(
      id: map['id'],
      idMovie: map['id_movie'],
      idProducer: map['id_producer'],
    );
  }
}