CREATE TABLE heart_rate_original (
    heart_rate_original_id INTEGER PRIMARY KEY AUTOINCREMENT
                                    UNIQUE
                                    NOT NULL,
    heart_rate REAL,
    unit TEXT,
    time_from TEXT,
    time_to TEXT,
    source_platform TEXT,
    source_device_id TEXT,
    source_name TEXT,
    recording_method TEXT
);
