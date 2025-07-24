import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user.db');

    return await openDatabase(path, version: 2, onCreate: (db, version) async {
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
    sex             TEXT   , 
    weight          REAL   , 
    weight_unit     TEXT   ,
    height          REAL   , 
    height_unit     TEXT   ,
    age             INTEGER ,
    RHR             REAL,
    PHR             TEXT,
    chatbot_summary TEXT,
    user_goal       TEXT
        )
      ''');
    });
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final dbClient = await db;
    return await dbClient.insert('user_dim', user);
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

}
