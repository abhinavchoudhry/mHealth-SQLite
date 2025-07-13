CREATE TABLE daily_activity_fact (
    daily_activity_fact_id INTEGER PRIMARY KEY AUTOINCREMENT
                                    UNIQUE
                                    NOT NULL,
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
