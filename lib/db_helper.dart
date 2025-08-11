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
<<<<<<< HEAD
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
=======
      path, 
      version: 3, // Incremented version to add exercise tables
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
        sex             TEXT   , 
        weight          REAL   , 
        weight_unit     TEXT   ,
        height          REAL   , 
        height_unit     TEXT   ,
        age             INTEGER ,
        RHR             REAL,
        PHR             TEXT,
        chatbot_summary TEXT,
        user_goal       TEXT)
        ''');

            // Create exercise_library_dim table (predefined exercises)
      await db.execute('''
        CREATE TABLE exercise_library_dim (
          exercise_library_dim_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
          exercise_name TEXT NOT NULL,
          target_area TEXT NOT NULL,
          description TEXT,
          equipment TEXT,
          instructions TEXT,
          warning TEXT,
          photo_position TEXT
        )
      ''');

      // Create user_custom_exercise_dim table (user-created exercises)
      await db.execute('''
        CREATE TABLE user_custom_exercise_dim (
          user_exercise_dim_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
          user_dim_id INTEGER NOT NULL,
          date_created TEXT NOT NULL,
          exercise_name TEXT NOT NULL,
          target_area TEXT NOT NULL,
          description TEXT,
          equipment TEXT,
          instructions TEXT,
          warning TEXT,
          photo_position TEXT,
          FOREIGN KEY (user_dim_id) REFERENCES user_dim(user_dim_id)
        )
      ''');
    });

    await _insertDefaultExercises(db);
>>>>>>> 3aecc5b (WIP: routine changes)
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
<<<<<<< HEAD
    final dbClient = await db;
    return await dbClient.query('user_dim');
=======
  final dbClient = await db;
  return await dbClient.query('user_dim');
>>>>>>> 3aecc5b (WIP: routine changes)
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
<<<<<<< HEAD

  Future<int> updateUser(int id, Map<String, dynamic> data) async {
    final dbClient = await db;
    return await dbClient.update(
      'user_dim',
      data,
      where: 'user_dim_id = ?',
      whereArgs: [id],
    );
=======
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

  // Insert some default exercises into the library
  Future<void> _insertDefaultExercises(Database db) async {
    final defaultExercises = [
      {
        'exercise_name': 'Push-ups',
        'target_area': 'Chest',
        'description': 'Classic bodyweight exercise for chest, shoulders, and triceps',
        'equipment': 'None',
        'instructions': '1. Start in plank position\n2. Lower body to ground\n3. Push back up',
        'warning': 'Keep core tight and avoid sagging hips'
      },
      {
        'exercise_name': 'Squats',
        'target_area': 'Legs',
        'description': 'Fundamental lower body exercise',
        'equipment': 'None',
        'instructions': '1. Stand with feet shoulder-width apart\n2. Lower as if sitting in chair\n3. Return to standing',
        'warning': 'Keep knees aligned with toes'
      },
      {
        'exercise_name': 'Plank',
        'target_area': 'Core',
        'description': 'Isometric core strengthening exercise',
        'equipment': 'None',
        'instructions': '1. Start in push-up position\n2. Hold position on forearms\n3. Keep body straight',
        'warning': 'Avoid sagging hips or raising buttocks'
      },
      {
        'exercise_name': 'Pull-ups',
        'target_area': 'Back',
        'description': 'Upper body pulling exercise',
        'equipment': 'Pull-up bar',
        'instructions': '1. Hang from bar with palms facing away\n2. Pull body up until chin over bar\n3. Lower with control',
        'warning': 'Use full range of motion, avoid swinging'
      },
    ];

    for (final exercise in defaultExercises) {
      await db.insert('exercise_library_dim', exercise);
    }
  }
   // ========== CUSTOM EXERCISE OPERATIONS ==========

  // CREATE - Add new custom exercise
  Future<int> insertCustomExercise(CustomExercise exercise) async {
    try {
      final dbClient = await db;
      final id = await dbClient.insert(
        'user_custom_exercise_dim',
        exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Custom exercise created with ID: $id');
      return id;
    } catch (e) {
      print('Error inserting custom exercise: $e');
      rethrow;
    }
  }

  // READ - Get all custom exercises for a specific user
  Future<List<CustomExercise>> getCustomExercisesByUser(int userId) async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query(
        'user_custom_exercise_dim',
        where: 'user_dim_id = ?',
        whereArgs: [userId],
        orderBy: 'date_created DESC',
      );
      
      return maps.map((map) => CustomExercise.fromMap(map)).toList();
    } catch (e) {
      print('Error getting custom exercises: $e');
      return [];
    }
  }

  // READ - Get single custom exercise by ID
  Future<CustomExercise?> getCustomExerciseById(int exerciseId) async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query(
        'user_custom_exercise_dim',
        where: 'user_exercise_dim_id = ?',
        whereArgs: [exerciseId],
        limit: 1,
      );
      
      if (maps.isNotEmpty) {
        return CustomExercise.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      print('Error getting custom exercise by ID: $e');
      return null;
    }
  }

  // UPDATE - Modify existing custom exercise
  Future<int> updateCustomExercise(CustomExercise exercise) async {
    try {
      final dbClient = await db;
      final rowsAffected = await dbClient.update(
        'user_custom_exercise_dim',
        exercise.toMap(),
        where: 'user_exercise_dim_id = ?',
        whereArgs: [exercise.id],
      );
      
      if (rowsAffected > 0) {
        print('Custom exercise updated successfully');
      } else {
        print('No exercise found with ID: ${exercise.id}');
      }
      
      return rowsAffected;
    } catch (e) {
      print('Error updating custom exercise: $e');
      rethrow;
    }
  }

  // DELETE - Remove custom exercise
  Future<int> deleteCustomExercise(int exerciseId) async {
    try {
      final dbClient = await db;
      final rowsAffected = await dbClient.delete(
        'user_custom_exercise_dim',
        where: 'user_exercise_dim_id = ?',
        whereArgs: [exerciseId],
      );
      
      if (rowsAffected > 0) {
        print('Custom exercise deleted successfully');
      } else {
        print('No exercise found with ID: $exerciseId');
      }
      
      return rowsAffected;
    } catch (e) {
      print('Error deleting custom exercise: $e');
      rethrow;
    }
  }

  // SEARCH - Find custom exercises by name or target area
  Future<List<CustomExercise>> searchCustomExercises(int userId, String searchTerm) async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query(
        'user_custom_exercise_dim',
        where: 'user_dim_id = ? AND (exercise_name LIKE ? OR target_area LIKE ?)',
        whereArgs: [userId, '%$searchTerm%', '%$searchTerm%'],
        orderBy: 'exercise_name ASC',
      );
      
      return maps.map((map) => CustomExercise.fromMap(map)).toList();
    } catch (e) {
      print('Error searching custom exercises: $e');
      return [];
    }
  }

  // ========== EXERCISE LIBRARY OPERATIONS ==========

  // READ - Get all exercises from library
  Future<List<ExerciseLibrary>> getAllLibraryExercises() async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query(
        'exercise_library_dim',
        orderBy: 'exercise_name ASC',
      );
      
      return maps.map((map) => ExerciseLibrary.fromMap(map)).toList();
    } catch (e) {
      print('Error getting library exercises: $e');
      return [];
    }
  }

  // READ - Get library exercises by target area
  Future<List<ExerciseLibrary>> getLibraryExercisesByTargetArea(String targetArea) async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query(
        'exercise_library_dim',
        where: 'target_area = ?',
        whereArgs: [targetArea],
        orderBy: 'exercise_name ASC',
      );
      
      return maps.map((map) => ExerciseLibrary.fromMap(map)).toList();
    } catch (e) {
      print('Error getting exercises by target area: $e');
      return [];
    }
  }

  // READ - Search library exercises
  Future<List<ExerciseLibrary>> searchLibraryExercises(String searchTerm) async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query(
        'exercise_library_dim',
        where: 'exercise_name LIKE ? OR target_area LIKE ?',
        whereArgs: ['%$searchTerm%', '%$searchTerm%'],
        orderBy: 'exercise_name ASC',
      );
      
      return maps.map((map) => ExerciseLibrary.fromMap(map)).toList();
    } catch (e) {
      print('Error searching library exercises: $e');
      return [];
    }
  }

  // CREATE - Add new exercise to library (admin function)
  Future<int> insertLibraryExercise(ExerciseLibrary exercise) async {
    try {
      final dbClient = await db;
      final id = await dbClient.insert(
        'exercise_library_dim',
        exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Library exercise created with ID: $id');
      return id;
    } catch (e) {
      print('Error inserting library exercise: $e');
      rethrow;
    }
>>>>>>> 3aecc5b (WIP: routine changes)
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
