import sqlite3

conn = sqlite3.connect('mhealth_local.db')
cursor = conn.cursor()

# 1. create_daily_activity_fact_table
cursor.execute('''
CREATE TABLE IF NOT EXISTS daily_activity_fact (
    daily_activity_fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    steps INTEGER,
    calories REAL,
    exercise_minutes INTEGER,
    sedentary_minutes INTEGER,
    active_minutes INTEGER,
    bpm_avg REAL,
    bpm_max REAL,
    stand_goal INTEGER,
    stand_achieved INTEGER
);
''')

# 2. create_daily_sleep_fact_table
cursor.execute('''
CREATE TABLE IF NOT EXISTS daily_sleep_fact (
    daily_sleep_fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    date TEXT,
    total_sleep_minutes INTEGER,
    awake_minutes INTEGER,
    deep_minutes INTEGER,
    light_minutes INTEGER,
    sedentary_sleep_minutes INTEGER,
    active_sleep_minutes INTEGER,
    avg_bpm REAL
);
''')

# 3. create_exercise_log_fact_table
cursor.execute('''
CREATE TABLE IF NOT EXISTS exercise_log_fact (
    exercise_log_fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    exercise_library_dim_id INTEGER,
    log_date TEXT,
    log_time TEXT,
    calories_burned REAL,
    FOREIGN KEY (exercise_library_dim_id) REFERENCES exercise_library_dim(exercise_library_dim_id)
);
''')

# 4. Create routine_exercise_fact table
cursor.execute('''
CREATE TABLE IF NOT EXISTS routine_exercise_fact (
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
''')

# 5. Create user_add_exercise_fact table
cursor.execute('''
CREATE TABLE IF NOT EXISTS user_add_exercise_fact (
    user_add_exercise_fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_dim_id INTEGER,
    exercise_library_dim_id INTEGER,
    date_added TEXT,
    FOREIGN KEY (user_dim_id) REFERENCES user_dim(user_dim_id),
    FOREIGN KEY (exercise_library_dim_id) REFERENCES exercise_library_dim(exercise_library_dim_id)
);
''')

# 6. Create workout_routine_fact table
cursor.execute('''
CREATE TABLE IF NOT EXISTS workout_routine_fact (
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
''')

# 7. Create workout_session_fact table
cursor.execute('''
CREATE TABLE IF NOT EXISTS workout_session_fact (
    workout_session_fact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    workout_name TEXT,
    workout_date TEXT,
    duration_min REAL,
    start_time TEXT,
    end_time TEXT,
    calories_burned REAL,
    avg_bpm REAL,
    max_bpm REAL
);
''')

# 8. Create active_energy_burned_original table
cursor.execute('''
CREATE TABLE IF NOT EXISTS active_energy_burned_original (
    active_energy_burned_original_id INTEGER PRIMARY KEY AUTOINCREMENT,
    active_energy_burned REAL,
    unit TEXT,
    time_from TEXT,
    time_to TEXT,
    source_platform TEXT,
    source_device_id TEXT,
    source_name TEXT,
    recording_method TEXT
);
''')

# 9. Create basal_energy_burned_original table
cursor.execute('''
CREATE TABLE IF NOT EXISTS basal_energy_burned_original (
    basal_energy_burned_original_id INTEGER PRIMARY KEY AUTOINCREMENT,
    basal_energy_burned REAL,
    unit TEXT,
    time_from TEXT,
    time_to TEXT,
    source_platform TEXT,
    source_device_id TEXT,
    source_name TEXT,
    recording_method TEXT
);
''')

# 10. Create heart_rate_original table
cursor.execute('''
CREATE TABLE IF NOT EXISTS heart_rate_original (
    heart_rate_original_id INTEGER PRIMARY KEY AUTOINCREMENT,
    heart_rate REAL,
    unit TEXT,
    time_from TEXT,
    time_to TEXT,
    source_platform TEXT,
    source_device_id TEXT,
    source_name TEXT,
    recording_method TEXT
);
''')

# 11. Create steps_original table
cursor.execute('''
CREATE TABLE IF NOT EXISTS steps_original (
    steps_original_id INTEGER PRIMARY KEY AUTOINCREMENT,
    steps INTEGER,
    unit TEXT,
    time_from TEXT,
    time_to TEXT,
    source_platform TEXT,
    source_device_id TEXT,
    source_name TEXT,
    recording_method TEXT
);
''')

# 12. Create workout_original table
cursor.execute('''
CREATE TABLE IF NOT EXISTS workout_original (
    workout_original_id INTEGER PRIMARY KEY AUTOINCREMENT,
    workout_activity_type TEXT,
    total_energy_burned REAL,
    total_energy_burned_unit TEXT,
    total_distance REAL,
    total_distance_unit TEXT,
    total_steps INTEGER,
    total_steps_unit TEXT,
    time_from TEXT,
    time_to TEXT,
    source_platform TEXT,
    source_device_id TEXT,
    source_name TEXT,
    recording_method TEXT
);
''')

# 13. Create user_dim table
cursor.execute('''
CREATE TABLE IF NOT EXISTS user_dim (
    user_dim_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT,
    pwd TEXT,
    email TEXT,
    first_name TEXT,
    last_name TEXT,
    dob TEXT,
    phone_number TEXT
);
''')

# 14. Create exercise_library_dim table
cursor.execute('''
CREATE TABLE IF NOT EXISTS exercise_library_dim (
    exercise_library_dim_id INTEGER PRIMARY KEY AUTOINCREMENT,
    exercise_name TEXT,
    target_area TEXT,
    description TEXT,
    equipment TEXT,
    instructions TEXT,
    warning TEXT
);
''')

conn.commit()
conn.close()

print("Database created")
