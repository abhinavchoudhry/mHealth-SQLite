import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(
      await getDatabasesPath(),
      'user.db',
    ); // Use your actual DB name
    if (await File(path).exists()) {
      await deleteDatabase(path);
      print('✅ Database deleted: $path');
    } else {
      print('⚠️ Database does not exist at: $path');
    }
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(
      path,
      version: 8,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE user_dim (
    user_dim_id     INTEGER PRIMARY KEY AUTOINCREMENT
                            UNIQUE
                            NOT NULL,
    username        TEXT    NOT NULL,
    pwd             TEXT    NOT NULL,
    email           TEXT    NOT NULL,
    first_name      TEXT    NOT NULL,
    last_name       TEXT    NOT NULL,
    dob             TEXT    NOT NULL,
    phone_number    TEXT    NOT NULL,
    sex             TEXT    NOT NULL,
    weight          REAL    NOT NULL,
    weight_unit     TEXT    NOT NULL,
    height          REAL    NOT NULL,
    height_unit     TEXT    NOT NULL,
    age             INTEGER NOT NULL,
    RHR             REAL,
    health_conditions TEXT,
    custom_goals   TEXT,
    ai_avatar_id   INTEGER,
    ai_personality TEXT,
    ai_voice       TEXT,
    chatbot_summary TEXT
        )
      ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final dbClient = await db;

    // Normalize all values to strings where appropriate
    final cleanedUser = <String, dynamic>{};

    user.forEach((key, value) {
      if (key == "weight" || key == "height" || key == "RHR") {
        cleanedUser[key] = double.parse(value);
      }
      if (key == "age" || key == "ai_avatar_id") {
        cleanedUser[key] = int.parse(value);
      } else {
        cleanedUser[key] = value;
      }
    });

    return await dbClient.insert('user_dim', cleanedUser);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final dbClient = await db;
    return await dbClient.query('user_dim');
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'user_dim',
      where: 'user_dim_id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<int> updateUser(int id, Map<String, dynamic> data) async {
    final dbClient = await db;
    return await dbClient.update(
      'user_dim',
      data,
      where: 'user_dim_id = ?',
      whereArgs: [id],
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final dbClient = await db;
    final result = await dbClient.query(
      'user_dim',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
