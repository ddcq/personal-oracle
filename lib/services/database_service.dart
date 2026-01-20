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
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'oracle_d_asgard.db');
      return await openDatabase(
        path,
        version: 5, // Increment version
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      // If database initialization fails, throw to be caught by caller
      throw Exception('Failed to initialize database: $e');
    }
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
      CREATE TABLE collectible_cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        card_id TEXT NOT NULL,
        version TEXT NOT NULL, -- Added version column
        unlocked_at INTEGER NOT NULL,
        UNIQUE(card_id, version) -- Ensure unique combination of card_id and version
      )
    ''');

    await _createStoryProgressTable(db);

    await db.execute('''
      CREATE TABLE quiz_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        deity_name TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE game_settings (
        setting_key TEXT PRIMARY KEY,
        setting_value TEXT
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createStoryProgressTable(db);
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE quiz_results (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          deity_name TEXT NOT NULL,
          timestamp INTEGER NOT NULL
        )
      ''');
    }
    if (oldVersion < 4) {
      // Migration for version 4
      await db.execute('''
        ALTER TABLE collectible_cards ADD COLUMN version TEXT DEFAULT 'epic' NOT NULL;
      ''');
      // Add a unique constraint if it doesn't exist, or handle existing duplicates
      // For simplicity, assuming no duplicates of card_id with different versions exist before this migration
      await db.execute('''
        CREATE UNIQUE INDEX IF NOT EXISTS idx_card_id_version ON collectible_cards (card_id, version);
      ''');
    }
    if (oldVersion < 5) {
      // Migration for version 5
      await db.execute('''
        CREATE TABLE game_settings (
          setting_key TEXT PRIMARY KEY,
          setting_value TEXT
        )
      ''');
    }
  }

  Future<void> _createStoryProgressTable(Database db) async {
    await db.execute('''
      CREATE TABLE story_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        story_id TEXT NOT NULL UNIQUE,
        parts_unlocked TEXT NOT NULL,
        unlocked_at INTEGER NOT NULL
      )
    ''');
  }

  Future<void> deleteDb() async {
    try {
      if (_database != null && _database!.isOpen) {
        await _database!.close();
        _database = null;
      }
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'oracle_d_asgard.db');
      await deleteDatabase(path);
      _database =
          null; // Ensure it's null so it gets reinitialized on next access
    } catch (e) {
      // Silently fail - this is a debug/reset function
      _database = null;
    }
  }

  Future<void> reinitializeDb() async {
    try {
      if (_database != null && _database!.isOpen) {
        await _database!.close();
        _database = null;
      }
      _database = await _initDatabase();
    } catch (e) {
      // Silently fail - this is a debug/reset function
      _database = null;
    }
  }

  Future<void> destroyAndRebuildDatabase() async {
    await deleteDb();
    await reinitializeDb();
  }
}
