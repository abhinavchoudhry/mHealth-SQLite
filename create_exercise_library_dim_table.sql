CREATE TABLE exercise_library_dim (
    exercise_library_dim_id INTEGER PRIMARY KEY AUTOINCREMENT,
    exercise_name TEXT,
    target_area TEXT,
    description TEXT,
    equipment TEXT,
    instructions TEXT,
    warning TEXT
);