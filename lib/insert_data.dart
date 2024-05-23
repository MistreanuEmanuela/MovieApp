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


var actor = Actor(
  name: 'Leonardo DiCaprio',
  bio: 'An American actor and film producer.',
  photoPath: 'lib/images/actors/leo.jpg', // Relative to the lib directory
);

var producer = Producer(
  name: 'Christopher Nolan',
  bio: 'An English-American film director, producer, and screenwriter.',
  photoPath: 'lib/images/producers/nolan.jpg', // Relative to the lib directory
);

  var role = Role(
    name: 'Dominick Cobb',
  );

  var movieActor = MovieActor(
    idMovie: 7,
    idActor: 2,
    idRole: 1,
  );

  var movieProducer = MovieProducer(
    idMovie: 6,
    idProducer: 2,
  );

  var genre = Genre(
    name: 'Science Fiction',
  );
  var genre1 = Genre(name: 'romance');
  var genre2= Genre(name:'drama' );

  var genreMovie = GenreMovie(
    idMovie: 6,
    idGenre: 1,
  );

  var genreMovie1 = GenreMovie(
    idMovie: 7,
    idGenre: 4,
  );
  var genreMovie2 = GenreMovie(
    idMovie: 8,
    idGenre: 2,
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
  // await dbHelper.insertGenreMovie(genreMovie1);
//  await dbHelper.insertActor(actor);
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
  var genres = await dbHelper.genres();
    for (var genre in genres) {
    print("Id: ${genre.id}");  
         print("name: ${genre.name}");
    }

  
   var actors = await dbHelper.actors();
    for (var actor in actors) {
    print("Id: ${actor.id}");  
    print("name: ${actor.name}");
    }

  }
  
var roles = await dbHelper.movieActor();
    for (var actor in roles) {
    print("Id: ${actor.id}");  
    print("name: ${actor.idActor}");
    print("name: ${actor.idMovie}");
    print("name: ${actor.idRole}");
    }

  
  // Delete all movies
  // await dbHelper.deleteAllMovies();
}