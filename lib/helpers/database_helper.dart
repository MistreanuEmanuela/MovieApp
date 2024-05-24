import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';
import '../models/movie.dart';
import '../models/actor.dart';
import '../models/producer.dart';
import '../models/role.dart';
import '../models/movie_actor.dart';
import '../models/movie_producer.dart';
import '../models/genre.dart';
import '../models/movie_genre.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'movie_app1.db'),
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _dropTables(db);
        await _createTables(db);
      },
      version: 2,
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute(
      "CREATE TABLE users(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, username TEXT, email TEXT, password TEXT)",
    );
    await db.execute(
      "CREATE TABLE movies(id INTEGER PRIMARY KEY, title TEXT, year INTEGER, plot TEXT, duration TEXT, photo_path TEXT)",
    );
    await db.execute(
      "CREATE TABLE actors(id INTEGER PRIMARY KEY, name TEXT, bio TEXT, photo_path TEXT)",
    );
    await db.execute(
      "CREATE TABLE producers(id INTEGER PRIMARY KEY, name TEXT, bio TEXT, photo_path TEXT)",
    );
    await db.execute(
      "CREATE TABLE roles(id INTEGER PRIMARY KEY, name TEXT)",
    );
    await db.execute(
      "CREATE TABLE movie_actor(id INTEGER PRIMARY KEY, id_movie INTEGER, id_actor INTEGER, id_role INTEGER, "
      "FOREIGN KEY(id_movie) REFERENCES movies(id), "
      "FOREIGN KEY(id_actor) REFERENCES actors(id), "
      "FOREIGN KEY(id_role) REFERENCES roles(id))",
    );
    await db.execute(
      "CREATE TABLE movie_producer(id INTEGER PRIMARY KEY, id_movie INTEGER, id_producer INTEGER, "
      "FOREIGN KEY(id_movie) REFERENCES movies(id), "
      "FOREIGN KEY(id_producer) REFERENCES producers(id))",
    );
    await db.execute(
      "CREATE TABLE genres(id INTEGER PRIMARY KEY, name TEXT)",
    );
    await db.execute(
      "CREATE TABLE genre_movies(id INTEGER PRIMARY KEY, id_movie INTEGER, id_genre INTEGER, "
      "FOREIGN KEY(id_movie) REFERENCES movies(id), "
      "FOREIGN KEY(id_genre) REFERENCES genres(id))",
    );

      await db.execute(
      "CREATE TABLE favorite_movies(id INTEGER PRIMARY KEY, id_movie INTEGER, id_user INTEGER, "
      "FOREIGN KEY(id_movie) REFERENCES movies(id), "
      "FOREIGN KEY(id_user) REFERENCES users(id))"
    );

    // Create favorite_actors table
    await db.execute(
      "CREATE TABLE favorite_actors(id INTEGER PRIMARY KEY, id_actor INTEGER, id_user INTEGER, "
      "FOREIGN KEY(id_actor) REFERENCES actors(id), "
      "FOREIGN KEY(id_user) REFERENCES users(id))"
    );
  }

  Future<void> _dropTables(Database db) async {
    await db.execute('DROP TABLE IF EXISTS users');
    await db.execute('DROP TABLE IF EXISTS movies');
    await db.execute('DROP TABLE IF EXISTS actors');
    await db.execute('DROP TABLE IF EXISTS producers');
    await db.execute('DROP TABLE IF EXISTS roles');
    await db.execute('DROP TABLE IF EXISTS movie_actor');
    await db.execute('DROP TABLE IF EXISTS movie_producer');
    await db.execute('DROP TABLE IF EXISTS genres');
    await db.execute('DROP TABLE IF EXISTS genre_movies');
  }

  // Future<List<String>> getAllTableNames() async {
  //   final db = await database;
  //   List<Map> maps = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table";');

  //   List<String> tableNameList = [];
  //   if (maps.isNotEmpty) {
  //     tableNameList = maps.map((map) => map['name'] as String).toList();
  //   }
  //   return tableNameList;
  // }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMovie(Movie movie) async {
    final db = await database;
    await db.insert(
      'movies',
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertActor(Actor actor) async {
    final db = await database;
    await db.insert(
      'actors',
      actor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertProducer(Producer producer) async {
    final db = await database;
    await db.insert(
      'producers',
      producer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertRole(Role role) async {
    final db = await database;
    await db.insert(
      'roles',
      role.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMovieActor(MovieActor movieActor) async {
    final db = await database;
    await db.insert(
      'movie_actor',
      movieActor.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertMovieProducer(MovieProducer movieProducer) async {
    final db = await database;
    await db.insert(
      'movie_producer',
      movieProducer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertGenre(Genre genre) async {
    final db = await database;
    await db.insert(
      'genres',
      genre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertGenreMovie(GenreMovie genreMovie) async {
    final db = await database;
    await db.insert(
      'genre_movies',
      genreMovie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> users() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<List<Movie>> movies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

    Future<List<Genre>> genres() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('genres');
    return List.generate(maps.length, (i) {
      return Genre.fromMap(maps[i]);
    });
  }

     Future<List<Map<String, dynamic>>> getAllFavoriteMovies() async {
    final db = await database;
    return db.query('favorite_movies');
    
  }
   Future<List<Actor>> actors() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('actors');
    return List.generate(maps.length, (i) {
      return Actor.fromMap(maps[i]);
    });
  }
 Future<List<Role>> roles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('roles');
    return List.generate(maps.length, (i) {
      return Role.fromMap(maps[i]);
    });
  }
 Future<List<MovieActor>> movieActor() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movie_actor');
    return List.generate(maps.length, (i) {
      return MovieActor.fromMap(maps[i]);
    });
  }

Future<List<Movie>> moviesByYearDesc() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query(
    'movies',
    orderBy: 'year DESC',
  );
  return List.generate(maps.length, (i) {
    return Movie.fromMap(maps[i]);
  });
}
Future<void> deleteMovie(int id) async {
    final db = await database;
    await db.delete(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


Future<void> deleteGenre(int id) async {
    final db = await database;
    await db.delete(
      'genres',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> deleteAllMovies() async {
    final db = await database;
    await db.delete('movies');
  }


  Future<List<Genre>> getGenresForMovie(int movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'genres',
      columns: ['id', 'name'],
      where: 'id IN (SELECT id_genre FROM genre_movies WHERE id_movie = ?)',
      whereArgs: [movieId ?? 0], // Handle nullable movieId
    );

    return List.generate(maps.length, (i) {
      return Genre(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }
Future<List<Genre>> getAllGenres() async {
  final db = await database;
  final List<Map<String, dynamic>> genreMaps = await db.query('genres');
  return List.generate(genreMaps.length, (i) {
    return Genre(
      id: genreMaps[i]['id'],
      name: genreMaps[i]['name'],
    );
  });
}
    Future<List<Movie>> getMoviesByGenre(String genreName) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT movies.* FROM movies 
      INNER JOIN genre_movies ON movies.id = genre_movies.id_movie
      INNER JOIN genres ON genre_movies.id_genre = genres.id
      WHERE genres.name = ?
      ''',
      [genreName],
    );

    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

   Future<Movie> getMovieById(int id) async {
    final db = await database;
    final maps = await db.query(
      'movies',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movie.fromMap(maps.first);
    } else {
      throw Exception('Movie not found');
    }
  }

 Future<List<Producer>> getProducersForMovie(int movieId) async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.rawQuery(
    '''
    SELECT producers.* FROM producers
    INNER JOIN movie_producer ON producers.id = movie_producer.id_producer
    WHERE movie_producer.id_movie = ?
    ''',
    [movieId],
  );

  if (maps.isNotEmpty) {
    return List.generate(maps.length, (i) {
      return Producer.fromMap(maps[i]);
    });
  } else {
    return []; // Return an empty list if no producers found
  }
}
  Future<List<Actor>> getActorsForMovie(int movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT actors.* FROM actors
      INNER JOIN movie_actor ON actors.id = movie_actor.id_actor
      WHERE movie_actor.id_movie = ?
      ''',
      [movieId],
    );

     if (maps.isNotEmpty) {
    return List.generate(maps.length, (i) {
      return Actor.fromMap(maps[i]);
    });
  } else {
    return []; // Return an empty list if no producers found
  }
  }

  Future<Role> getRoleForMovieActor(int movieId, int actorId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT roles.* FROM roles
      INNER JOIN movie_actor ON roles.id = movie_actor.id_role
      WHERE movie_actor.id_movie = ? AND movie_actor.id_actor = ?
      ''',
      [movieId, actorId],
    );

    if (maps.isNotEmpty) {
      return Role.fromMap(maps.first);
    } else {
      throw Exception('Role not found for the movie and actor');
    }
  }
   Future<void> insertFavoriteMovie(int movieId, int userId) async {
    final db = await database;
    await db.insert(
      'favorite_movies',
      {'id_movie': movieId, 'id_user': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertFavoriteActor(int actorId, int userId) async {
    final db = await database;
    await db.insert(
      'favorite_actors',
      {'id_actor': actorId, 'id_user': userId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavoriteMovie(int movieId, int userId) async {
    final db = await database;
    await db.delete(
      'favorite_movies',
      where: 'id_movie = ? AND id_user = ?',
      whereArgs: [movieId, userId],
    );
  }

  Future<void> deleteFavoriteActor(int actorId, int userId) async {
    final db = await database;
    await db.delete(
      'favorite_actors',
      where: 'id_actor = ? AND id_user = ?',
      whereArgs: [actorId, userId],
    );
  }

  Future<List<Movie>> getFavoriteMoviesForUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_movies',
      where: 'id_user = ?',
      whereArgs: [userId],
    );

    final List<Movie> movies = [];
    for (final map in maps) {
      final int movieId = map['id_movie'];
      final movie = await getMovieById(movieId);
      movies.add(movie);
    }
    return movies;
  }

  Future<List<Actor>> getFavoriteActorsForUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_actors',
      where: 'id_user = ?',
      whereArgs: [userId],
    );
  Future<Actor> getActorById(int id) async {
      final db = await database;
      final maps = await db.query(
        'actors',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return Actor.fromMap(maps.first);
      } else {
        throw Exception('Actor not found');
      }
    }
    final List<Actor> actors = [];
    for (final map in maps) {
      final int actorId = map['id_actor'];
      final actor = await getActorById(actorId);
      actors.add(actor);
    }
    return actors;
  }
Future<bool> checkPreferences(int userId, int movieId) async {
  final db = await database;
  final List<Map<String, dynamic>> result = await db.query(
    'favorite_movies',
    where: 'id_user = ? AND id_movie = ?',
    whereArgs: [userId, movieId],
  );

  return result.isNotEmpty;
}
Future<Actor> getActorById(int actorId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'actors',
      where: 'id = ?',
      whereArgs: [actorId],
    );

    if (maps.isNotEmpty) {
      return Actor.fromMap(maps.first);
    } else {
      throw Exception('Actor with id $actorId not found');
    }
  }

  Future<List<Movie>> getMoviesForActor(int actorId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT movies.* FROM movies '
      'INNER JOIN movie_actor ON movies.id = movie_actor.id_movie '
      'WHERE movie_actor.id_actor = ?',
      [actorId],
    );

    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }
Future<bool> checkPreferencesActor(int userId, int actorId) async {
  final db = await database;
  final List<Map<String, dynamic>> result = await db.query(
    'favorite_actors',
    where: 'id_user = ? AND id_actor = ?',
    whereArgs: [userId, actorId],
  );

  return result.isNotEmpty;
}

   Future<List<Movie>> getTopMovies() async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.rawQuery(
    '''
    SELECT movies.* FROM movies 
    LIMIT 3
    ''',
  );

  return List.generate(maps.length, (i) {
    return Movie.fromMap(maps[i]);
  });
}

Future<List<Movie>> searchMovies(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'movies',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Movie.fromMap(maps[i]);
    });
  }

}
