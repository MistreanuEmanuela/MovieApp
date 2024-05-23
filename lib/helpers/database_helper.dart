import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user.dart';

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
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop existing tables if they exist
        await _dropTables(db);
        // Recreate tables with updated schema
        await _createTables(db);
      },
      version: 2, // Increment the version number if needed
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

  Future<List<User>> users() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }
}
