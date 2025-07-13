CREATE TABLE daily_sleep_fact (
    daily_sleep_fact_id INTEGER PRIMARY KEY AUTOINCREMENT
                                    UNIQUE
                                    NOT NULL,
    date TEXT,
    total_sleep_minutes INTEGER,
    awake_minutes INTEGER,
    deep_minutes INTEGER,
    light_minutes INTEGER,
    sedentary_sleep_minutes INTEGER,
    active_sleep_minutes INTEGER,
    avg_bpm REAL
);
