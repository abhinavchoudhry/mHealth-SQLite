CREATE TABLE workout_original (
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
