CREATE TABLE exercise_log_fact (
    exercise_log_fact_id INTEGER PRIMARY KEY AUTOINCREMENT
                                    UNIQUE
                                    NOT NULL,
    exercise_library_dim_id INTEGER,
    log_date TEXT,
    log_time TEXT,
    calories_burned REAL,
    FOREIGN KEY (exercise_library_dim_id) REFERENCES exercise_library_dim(exercise_library_dim_id)
);
