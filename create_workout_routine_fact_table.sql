CREATE TABLE workout_routine_fact (
    workout_routine_fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_dim_id INTEGER,
    workout_routine_name TEXT,
    created_at TEXT,
    is_ai_generated INTEGER, -- 1 = true, 0 = false
    repetitions INTEGER,
    sets INTEGER,
    weight INTEGER,
    FOREIGN KEY (user_dim_id) REFERENCES user_dim(user_dim_id)
);