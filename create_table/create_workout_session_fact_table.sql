CREATE TABLE workout_session_fact (
    workout_session_fact_id INTEGER PRIMARY KEY AUTOINCREMENT
                                    UNIQUE
                                    NOT NULL,
    workout_name TEXT,
    workout_date TEXT,
    duration_min REAL,
    start_time TEXT,
    end_time TEXT,
    calories_burned REAL,
    avg_bpm REAL,
    max_bpm REAL,
    distance REAL
);
