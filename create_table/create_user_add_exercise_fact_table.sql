CREATE TABLE user_add_exercise_fact (
    user_add_exercise_fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_dim_id INTEGER,
    exercise_library_dim_id INTEGER,
    date_added TEXT,
    FOREIGN KEY (user_dim_id) REFERENCES user_dim(user_dim_id),
    FOREIGN KEY (exercise_library_dim_id) REFERENCES exercise_library_dim(exercise_library_dim_id)
);
