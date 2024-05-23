import './helpers/database_helper.dart';
import './models/actor.dart';
import './models/genre.dart';
import './models/movie.dart';
import './models/movie_actor.dart';
import './models/movie_genre.dart';
import './models/movie_producer.dart';
import './models/producer.dart';
import './models/role.dart';

Future<void> insertInitialData() async {
  final dbHelper = DatabaseHelper();

  // Example data
 var movie = Movie(
  title: 'Inception',
  year: 2010,
  plot: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
  duration: '148 minutes',
  photoPath: 'lib/images/movies/inception.png', // Relative to the lib directory
);
 var movie1 = Movie(
  title: 'Inception1',
  year: 2010,
  plot: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
  duration: '148 minutes',
  photoPath: 'lib/images/movies/inception.png', // Relative to the lib directory
);

 var movie2 = Movie(
  title: 'Inception2',
  year: 2010,
  plot: 'A thief who steals corporate secrets through the use of dream-sharing technology.',
  duration: '148 minutes',
  photoPath: 'lib/images/movies/inception.png', // Relative to the lib directory
);
//  await dbHelper.insertMovie(movie);
//   await dbHelper.insertMovie(movie1);
//   await dbHelper.insertMovie(movie2);

var actor = Actor(
  name: 'Leonardo DiCaprio',
  bio: 'An American actor and film producer.',
  photoPath: 'lib/images/actors/leo.jpg', // Relative to the lib directory
);
// await dbHelper.insertActor(actor);
var producer = Producer(
  name: 'Christopher Nolan',
  bio: 'An English-American film director, producer, and screenwriter.',
  photoPath: 'lib/images/producers/nolan.jpg', // Relative to the lib directory
);
// await dbHelper.insertProducer(producer);
  var role = Role(
    name: 'Dominick Cobb',
  );
// await dbHelper.insertRole(role);
  var movieActor = MovieActor(
    idMovie: 2,
    idActor: 1,
    idRole: 1,
  );
// await dbHelper.insertMovieActor(movieActor);
// await dbHelper.insertMovieActor(movieActor);
// await dbHelper.insertMovieActor(movieActor);
// await dbHelper.insertMovieActor(movieActor);
  var movieProducer = MovieProducer(
    idMovie: 2,
    idProducer: 1,
  );
// await dbHelper.insertMovieProducer(movieProducer);
// await dbHelper.insertMovieProducer(movieProducer);
// await dbHelper.insertMovieProducer(movieProducer);
// await dbHelper.insertMovieProducer(movieProducer);
  var genre = Genre(
    name: 'Science Fiction',
  );
  var genre1 = Genre(name: 'romance');
  var genre2= Genre(name:'drama' );

  var genreMovie = GenreMovie(
    idMovie: 2,
    idGenre: 1,
  );

  var genreMovie1 = GenreMovie(
    idMovie: 6,
    idGenre: 2,
  );
  var genreMovie2 = GenreMovie(
    idMovie: 2,
    idGenre: 3,
  );
  
  // await dbHelper.insertMovie(movie);
  // await dbHelper.insertMovie(movie1);
  //   await dbHelper.insertMovie(movie2);
      
  // await dbHelper.insertActor(actor);
  // await dbHelper.insertProducer(producer);
  // await dbHelper.insertRole(role);
  // await dbHelper.insertMovieActor(movieActor);
  // await dbHelper.insertMovieProducer(movieProducer);
  //   await dbHelper.insertMovieProducer(movieProducer);
  //     await dbHelper.insertMovieProducer(movieProducer);
  //       await dbHelper.insertMovieProducer(movieProducer);
  // await dbHelper.insertGenre(genre);
  // await dbHelper.insertGenreMovie(genreMovie);
  //   await dbHelper.insertGenre(genre1);
  // await dbHelper.insertGenreMovie(genreMovie1);
  //   await dbHelper.insertGenre(genre2);
  // await dbHelper.insertGenreMovie(genreMovie2);
//  await dbHelper.insertActor(actor);
// await dbHelper.insertMovieActor(movieActor);
// await dbHelper.insertMovieActor(movieActor);
// await dbHelper.insertMovieActor(movieActor);
// await dbHelper.insertMovieActor(movieActor);
// await dbHelper.insertMovieActor(movieActor);
  var users = await dbHelper.users();

  print(users);

  var movies = await dbHelper.movies();

 // Delete a movie (by id)
  await dbHelper.deleteMovie(4); // Assuming the id of 'Inception' is 1
  await dbHelper.deleteMovie(5); // Assuming the id of 'Inception' is 1

  // Print remaining movies after deletion
  print("Movies after deletion:");
  for (var movie in movies) {
    print("Id: ${movie.id}");
    print("Title: ${movie.title}");
    print("Year: ${movie.year}");
    print("Plot: ${movie.plot}");
    print("Duration: ${movie.duration}");
    print("Photo Path: ${movie.photoPath}");
    print("---------------------");
  }
  await dbHelper.deleteGenre(12);
  await dbHelper.deleteGenre(13);
  await dbHelper.deleteGenre(14);
  await dbHelper.deleteGenre(15);
  await dbHelper.deleteGenre(8);
  await dbHelper.deleteGenre(9);
  await dbHelper.deleteGenre(10);
  await dbHelper.deleteGenre(11);
var favoriteMovies = await dbHelper.getAllFavoriteMovies();
for (var movie in favoriteMovies) {
  print("Movie ID: ${movie['id_movie']}");  
  print("User ID: ${movie['id_user']}");
  // Print other movie details as needed
}
await dbHelper.deleteFavoriteMovie(1, 1);
await dbHelper.deleteFavoriteMovie(2, 1);

  
//    var actors = await dbHelper.actors();
//     for (var actor in actors) {
//     print("Id: ${actor.id}");  
//     print("name: ${actor.name}");
//     }

//   }
  
// var roles = await dbHelper.movieActor();
//     for (var actor in roles) {
//     print("Id: ${actor.id}");  
//     print("name: ${actor.idActor}");
//     print("name: ${actor.idMovie}");
//     print("name: ${actor.idRole}");
//     }

  
  // Delete all movies
  // await dbHelper.deleteAllMovies();
}