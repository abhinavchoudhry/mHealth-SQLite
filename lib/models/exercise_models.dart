class CustomExercise {
  final int? id;
  final int userDimId;
  final String dateCreated;
  final String exerciseName;
  final String targetArea;
  final String? description;
  final String? equipment;
  final String? instructions;
  final String? warning;
  final String? photoPosition;

  CustomExercise({
    this.id,
    required this.userDimId,
    required this.dateCreated,
    required this.exerciseName,
    required this.targetArea,
    this.description,
    this.equipment,
    this.instructions,
    this.warning,
    this.photoPosition,
  });

  // Convert object to Map for database operations
  Map<String, dynamic> toMap() => {
    'user_dim_id': userDimId,
    'date_created': dateCreated,
    'exercise_name': exerciseName,
    'target_area': targetArea,
    'description': description,
    'equipment': equipment,
    'instructions': instructions,
    'warning': warning,
    'photo_position': photoPosition,
  };

  // Create object from database Map
  factory CustomExercise.fromMap(Map<String, dynamic> map) => CustomExercise(
    id: map['user_exercise_dim_id'],
    userDimId: map['user_dim_id'] ?? 0,
    dateCreated: map['date_created'] ?? '',
    exerciseName: map['exercise_name'] ?? '',
    targetArea: map['target_area'] ?? '',
    description: map['description'],
    equipment: map['equipment'],
    instructions: map['instructions'],
    warning: map['warning'],
    photoPosition: map['photo_position'],
  );

  // Create a copy with modified fields (useful for editing)
  CustomExercise copyWith({
    int? id,
    int? userDimId,
    String? dateCreated,
    String? exerciseName,
    String? targetArea,
    String? description,
    String? equipment,
    String? instructions,
    String? warning,
    String? photoPosition,
  }) => CustomExercise(
    id: id ?? this.id,
    userDimId: userDimId ?? this.userDimId,
    dateCreated: dateCreated ?? this.dateCreated,
    exerciseName: exerciseName ?? this.exerciseName,
    targetArea: targetArea ?? this.targetArea,
    description: description ?? this.description,
    equipment: equipment ?? this.equipment,
    instructions: instructions ?? this.instructions,
    warning: warning ?? this.warning,
    photoPosition: photoPosition ?? this.photoPosition,
  );

  @override
  String toString() => 'CustomExercise(id: $id, name: $exerciseName, targetArea: $targetArea)';
}

class ExerciseLibrary {
  final int? id;
  final String exerciseName;
  final String targetArea;
  final String? description;
  final String? equipment;
  final String? instructions;
  final String? warning;
  final String? photoPosition;

  ExerciseLibrary({
    this.id,
    required this.exerciseName,
    required this.targetArea,
    this.description,
    this.equipment,
    this.instructions,
    this.warning,
    this.photoPosition,
  });

  Map<String, dynamic> toMap() => {
    'exercise_name': exerciseName,
    'target_area': targetArea,
    'description': description,
    'equipment': equipment,
    'instructions': instructions,
    'warning': warning,
    'photo_position': photoPosition,
  };

  factory ExerciseLibrary.fromMap(Map<String, dynamic> map) => ExerciseLibrary(
    id: map['exercise_library_dim_id'],
    exerciseName: map['exercise_name'] ?? '',
    targetArea: map['target_area'] ?? '',
    description: map['description'],
    equipment: map['equipment'],
    instructions: map['instructions'],
    warning: map['warning'],
    photoPosition: map['photo_position'],
  );

  @override
  String toString() => 'ExerciseLibrary(id: $id, name: $exerciseName, targetArea: $targetArea)';
}