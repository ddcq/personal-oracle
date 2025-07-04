import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'personal_oracle.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE game_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        game_name TEXT NOT NULL,
        score INTEGER NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE player_trophies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trophy_id TEXT NOT NULL UNIQUE,
        unlocked_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE collectible_cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        card_id TEXT NOT NULL UNIQUE,
        unlocked_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE unlocked_stories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        story_id TEXT NOT NULL UNIQUE,
        unlocked_at INTEGER NOT NULL
      )
    ''');
  }
}