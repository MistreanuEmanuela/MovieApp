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
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, username TEXT, email TEXT, password TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop existing table if it exists
        await db.execute('DROP TABLE IF EXISTS users');
        // Recreate table with updated schema
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, firstname TEXT, lastname TEXT, username TEXT, email TEXT, password TEXT)",
        );
      },
      version: 2, // Increment the version number
    );
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

