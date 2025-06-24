CREATE TABLE routine_exercise_fact (
    routine_exercise_fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    workout_routine_fact_id INTEGER,
    exercise_id INTEGER,
    repetitions INTEGER,
    sets INTEGER,
    weight INTEGER,
    weight_unit TEXT,
    FOREIGN KEY (workout_routine_fact_id) REFERENCES workout_routine_fact(workout_routine_fact_id),
    FOREIGN KEY (exercise_id) REFERENCES exercise_library_dim(exercise_library_dim_id)
);
