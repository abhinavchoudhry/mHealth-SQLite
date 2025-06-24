CREATE TABLE steps_original (
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