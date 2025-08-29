import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'models/exercise_models.dart';
import 'models/workout_routine.dart';
import 'models/routine_exercise.dart';
import 'models/ai_routine_request.dart';


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
      version: 13,
      onCreate: (db, version) async {
        print('🔨 Creating database tables (version $version)...');
        await _createAllTables(db);
        await _insertDefaultExercises(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print('🔄 Upgrading database from version $oldVersion to $newVersion...');
        // Add migration logic based on version
        if (oldVersion < 11) {
          await _createWorkoutTables(db);
        }
        if (oldVersion < 13) {
          await db.execute('DROP TABLE IF EXISTS ai_routine_requests');
          await _createWorkoutTables(db);
        }
      },
      onOpen: (db) async {
        // Enable foreign key constraints
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

// Create all tables (for onCreate)
  Future<void> _createAllTables(Database db) async {
    // User table
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

    // Exercise library table
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

    // User custom exercises table
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

    // Create workout tables
    await _createWorkoutTables(db);
  }

  // Create workout-related tables
  Future<void> _createWorkoutTables(Database db) async {
  await db.execute('''
    CREATE TABLE IF NOT EXISTS workout_routine_fact (
      workout_routine_fact_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
      user_dim_id INTEGER NOT NULL,
      workout_routine_name TEXT NOT NULL,
      created_at TEXT NOT NULL,
      is_ai_generated INTEGER DEFAULT 0,
      FOREIGN KEY (user_dim_id) REFERENCES user_dim(user_dim_id)
    )
  ''');

  await db.execute('''
    CREATE TABLE IF NOT EXISTS routine_exercise_fact (
      routine_exercise_fact_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
      workout_routine_fact_id INTEGER NOT NULL,
      exercise_library_dim_id INTEGER,
      user_exercise_dim_id INTEGER,
      repetitions INTEGER NOT NULL,
      sets INTEGER NOT NULL,
      weight INTEGER DEFAULT 0,
      weight_unit TEXT DEFAULT 'lbs',
      FOREIGN KEY (workout_routine_fact_id) REFERENCES workout_routine_fact(workout_routine_fact_id),
      FOREIGN KEY (exercise_library_dim_id) REFERENCES exercise_library_dim(exercise_library_dim_id),
      FOREIGN KEY (user_exercise_dim_id) REFERENCES user_custom_exercise_dim(user_exercise_dim_id),
      CHECK (
        (exercise_library_dim_id IS NOT NULL AND user_exercise_dim_id IS NULL)
        OR (exercise_library_dim_id IS NULL AND user_exercise_dim_id IS NOT NULL)
      )
    )
  ''');

  await db.execute('''
    CREATE TABLE ai_routine_requests (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      target_areas TEXT,
      duration_minutes INTEGER,
      intensity TEXT CHECK (intensity IN ('Light', 'Moderate', 'Intense')),
      goals TEXT,
      custom_goals TEXT,
      health_conditions TEXT, 
      fitness_level TEXT CHECK (fitness_level IN ('Beginner', 'Intermediate', 'Expert')),
      additional_comments TEXT,
      status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
      generated_routine_id INTEGER,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES user_dim(user_dim_id) ON DELETE CASCADE
    )
  ''');
}

  // Insert default exercises into the library
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


  Future<int> insertUser(Map<String, dynamic> user) async {
    final dbClient = await db;

    final cleanedUser = <String, dynamic>{};

    user.forEach((key, value) {
      if (key == "weight" || key == "height" || key == "RHR") {
        cleanedUser[key] = (value is num) ? value.toDouble() : double.parse(value.toString().trim());

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


  Future<int> insertWorkoutRoutine(WorkoutRoutine routine) async {
    try {
      final dbClient = await db;
      final id = await dbClient.insert(
        'workout_routine_fact',
        routine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Workout routine created with ID: $id');
      return id;
    } catch (e) {
      print('Error inserting workout routine: $e');
      rethrow;
    }
  }

  Future<int> insertRoutineExercise(RoutineExercise exercise) async {
    try {
      final dbClient = await db;
      final id = await dbClient.insert(
        'routine_exercise_fact',
        exercise.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Routine exercise added with ID: $id');
      return id;
    } catch (e) {
      print('Error inserting routine exercise: $e');
      rethrow;
    }
  }

  Future<int> saveCompleteRoutine(WorkoutRoutine routine, List<RoutineExercise> exercises) async {
    try {
      final dbClient = await db;
      
      return await dbClient.transaction((txn) async {
        // Insert the routine first
        final routineId = await txn.insert('workout_routine_fact', routine.toMap());
        
        // Insert all exercises for this routine
        for (final exercise in exercises) {
          final exerciseWithRoutineId = RoutineExercise(
            workoutRoutineFactId: routineId,
            exerciseLibraryDimId: exercise.exerciseLibraryDimId,
            userExerciseDimId: exercise.userExerciseDimId,
            repetitions: exercise.repetitions,
            sets: exercise.sets,
            weight: exercise.weight,
            weightUnit: exercise.weightUnit,
          );
          
          await txn.insert('routine_exercise_fact', exerciseWithRoutineId.toMap());
        }
        
        print('Complete routine saved with ID: $routineId and ${exercises.length} exercises');
        return routineId;
      });
    } catch (e) {
      print('Error saving complete routine: $e');
      rethrow;
    }
  }

  Future<List<WorkoutRoutine>> getWorkoutRoutinesByUser(int userId) async {
    try {
      final dbClient = await db;
      final maps = await dbClient.query(
        'workout_routine_fact',
        where: 'user_dim_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );
      
      return maps.map((map) => WorkoutRoutine.fromMap(map)).toList();
    } catch (e) {
      print('Error getting workout routines: $e');
      return [];
    }
  }

  Future<List<RoutineExercise>> getRoutineExercisesWithDetails(int routineId) async {
    try {
      final dbClient = await db;
      final maps = await dbClient.rawQuery('''
        SELECT 
          re.*,
          COALESCE(el.exercise_name, ce.exercise_name) as exercise_name,
          COALESCE(el.target_area, ce.target_area) as target_area
        FROM routine_exercise_fact re
        LEFT JOIN exercise_library_dim el ON re.exercise_library_dim_id = el.exercise_library_dim_id
        LEFT JOIN user_custom_exercise_dim ce ON re.user_exercise_dim_id = ce.user_exercise_dim_id
        WHERE re.workout_routine_fact_id = ?
        ORDER BY re.routine_exercise_fact_id ASC
      ''', [routineId]);
      
      return maps.map((map) => RoutineExercise.fromMap(map)).toList();
    } catch (e) {
      print('Error getting routine exercises: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getCompleteRoutine(int routineId) async {
    try {
      final dbClient = await db;
      
      // Get routine details
      final routineMaps = await dbClient.query(
        'workout_routine_fact',
        where: 'workout_routine_fact_id = ?',
        whereArgs: [routineId],
        limit: 1,
      );
      
      if (routineMaps.isEmpty) return null;
      
      final routine = WorkoutRoutine.fromMap(routineMaps.first);
      final exercises = await getRoutineExercisesWithDetails(routineId);
      
      return {
        'routine': routine,
        'exercises': exercises,
      };
    } catch (e) {
      print('Error getting complete routine: $e');
      return null;
    }
  }

  Future<int> deleteWorkoutRoutine(int routineId) async {
    try {
      final dbClient = await db;
      
      return await dbClient.transaction((txn) async {
        // Delete all exercises first
        await txn.delete(
          'routine_exercise_fact',
          where: 'workout_routine_fact_id = ?',
          whereArgs: [routineId],
        );
        
        // Then delete the routine
        final rowsAffected = await txn.delete(
          'workout_routine_fact',
          where: 'workout_routine_fact_id = ?',
          whereArgs: [routineId],
        );
        
        print('Routine and exercises deleted');
        return rowsAffected;
      });
    } catch (e) {
      print('Error deleting workout routine: $e');
      rethrow;
    }
  }


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
  }
  
  
  Future<int> insertAIRoutineRequest(AIRoutineRequest request) async {
    final dbClient = await db;
    final now = DateTime.now().toIso8601String();
    
    final requestMap = request.toMap();
    requestMap['created_at'] = now;
    requestMap['updated_at'] = now;
    
    return await dbClient.insert('ai_routine_requests', requestMap);
  }

  Future<int> updateAIRoutineRequest(AIRoutineRequest request) async {
    final dbClient = await db;
    final requestMap = request.toMap();
    requestMap['updated_at'] = DateTime.now().toIso8601String();
    
    return await dbClient.update(
      'ai_routine_requests',
      requestMap,
      where: 'id = ?',
      whereArgs: [request.id],
    );
  }

  Future<AIRoutineRequest?> getAIRoutineRequest(int id) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'ai_routine_requests',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return AIRoutineRequest.fromMap(maps.first);
    }
    return null;
  }

  Future<List<AIRoutineRequest>> getUserAIRoutineRequests(int userId) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'ai_routine_requests',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return AIRoutineRequest.fromMap(maps[i]);
    });
  }

  Future<List<AIRoutineRequest>> getRequestsByStatus(String status) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'ai_routine_requests',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return AIRoutineRequest.fromMap(maps[i]);
    });
  }

  Future<int> updateRequestStatus(int id, String status) async {
    final dbClient = await db;
    return await dbClient.update(
      'ai_routine_requests',
      {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAIRoutineRequest(int id) async {
    final dbClient = await db;
    return await dbClient.delete(
      'ai_routine_requests',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}