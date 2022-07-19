import 'dart:core';
import 'package:path/path.dart';
import 'package:restaurant_api/data/model/restaurant_list.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._internal() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._internal();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initializeDb();

    return _database;
  }

  static const String _tableName = 'favorite_resto';

  Future<Database> _initializeDb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'restaurant_db.db');

    var db = openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            pictureId TEXT, name TEXT, 
            city TEXT, rating REAL,
            description TEXT
        )''',
        );
      },
      version: 1
    );

    return db;
  }

  Future<void> insertRestaurant(Restaurant restaurant) async {
    final Database db = await database;
    await db.insert(_tableName, restaurant.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Restaurant>> getRestaurant() async {
    final Database db = await database;
    List<Map<String, dynamic>> results = await db.query(_tableName);

    return results.map((res) => Restaurant.fromMap(res)).toList();
  }

  Future<void> deleteRestaurant(String id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id]
    );
  }

  Future<Restaurant> getRestaurantById(String id) async {
    final Database db = await database;

    List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id]
    );

    return results.map((res) => Restaurant.fromMap(res)).first;
  }
}