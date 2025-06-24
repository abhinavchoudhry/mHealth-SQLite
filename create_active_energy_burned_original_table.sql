CREATE TABLE active_energy_burned_original (
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