CREATE TABLE user_custom_exercise_dim (
    user_exercise_dim_id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
    user_dim_id INTEGER NOT NULL,
    date_created TEXT,
    exercise_name TEXT,
    target_area TEXT,
    description TEXT,
    equipment TEXT,
    instructions TEXT,
    warning TEXT,
    photo_position TEXT,
    FOREIGN KEY (user_dim_id) REFERENCES user_dim(user_dim_id)
);