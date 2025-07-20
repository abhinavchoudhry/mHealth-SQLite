CREATE TABLE routine_exercise_fact (
    routine_exercise_fact_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
    workout_routine_fact_id INTEGER NOT NULL,

    exercise_library_dim_id INTEGER,  -- optional FK to predefined exercises
    user_exercise_dim_id INTEGER,     -- optional FK to user-created exercises

    repetitions INTEGER,
    sets INTEGER,
    weight INTEGER,
    weight_unit TEXT,

    FOREIGN KEY (workout_routine_fact_id) REFERENCES workout_routine_fact(workout_routine_fact_id),
    FOREIGN KEY (exercise_library_dim_id) REFERENCES exercise_library_dim(exercise_library_dim_id),
    FOREIGN KEY (user_exercise_dim_id) REFERENCES user_custom_exercise_dim(user_exercise_dim_id),

    CHECK (
        (exercise_library_dim_id IS NOT NULL AND user_exercise_dim_id IS NULL)
        OR (exercise_library_dim_id IS NULL AND user_exercise_dim_id IS NOT NULL)
    )
);

