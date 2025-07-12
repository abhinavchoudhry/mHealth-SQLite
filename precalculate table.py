import sqlite3
import random

# Custom path
# db_path = '/path/to/your/database/mhealth_local.db'
# conn = sqlite3.connect(db_path)
conn = sqlite3.connect("mhealth_local.db")
cursor = conn.cursor()

# Optional: Clear previous entries
# cursor.execute("DELETE FROM workout_session_fact")

cursor.execute("""
INSERT INTO workout_session_fact (
    workout_name,
    workout_date,
    duration_min,
    start_time,
    end_time,
    calories_burned,
    avg_bpm,
    max_bpm
)
SELECT
    w.workout_activity_type AS workout_name,
    DATE(w.time_from) AS workout_date,
    CAST((JULIANDAY(w.time_to) - JULIANDAY(w.time_from)) * 24 * 60 AS REAL) AS duration_min,
    w.time_from AS start_time,
    w.time_to AS end_time,
    w.total_energy_burned AS calories_burned,
    (SELECT AVG(hr.heart_rate)
     FROM heart_rate_original hr
     WHERE hr.time_from >= w.time_from AND hr.time_to <= w.time_to) AS avg_bpm,
    (SELECT MAX(hr.heart_rate)
     FROM heart_rate_original hr
     WHERE hr.time_from >= w.time_from AND hr.time_to <= w.time_to) AS max_bpm
FROM workout_original w;
""")

cursor.execute("SELECT DISTINCT DATE(time_from) FROM steps_original")
dates = [row[0] for row in cursor.fetchall()]

for date in dates:
    # Total steps
    cursor.execute("""
        SELECT SUM(steps) FROM steps_original
        WHERE DATE(time_from) = ?
    """, (date,))
    steps = cursor.fetchone()[0] or 0

    # Total calories
    cursor.execute("""
        SELECT COALESCE(SUM(active_energy_burned), 0) FROM active_energy_burned_original
        WHERE DATE(time_from) = ?
    """, (date,))
    active_cal = cursor.fetchone()[0]

    cursor.execute("""
        SELECT COALESCE(SUM(basal_energy_burned), 0) FROM basal_energy_burned_original
        WHERE DATE(time_from) = ?
    """, (date,))
    basal_cal = cursor.fetchone()[0]

    calories = active_cal + basal_cal

    # Exercise minutes
    cursor.execute("""
        SELECT COALESCE(SUM(duration_min), 0) FROM workout_session_fact
        WHERE workout_date = ?
    """, (date,))
    exercise_minutes = round(cursor.fetchone()[0])

    # Active minutes = distinct hours with steps > 0 + exercise minutes
    cursor.execute("""
        SELECT COUNT(DISTINCT strftime('%H', time_from)) FROM steps_original
        WHERE DATE(time_from) = ? AND steps > 0
    """, (date,))
    step_hours = cursor.fetchone()[0] or 0
    active_minutes = step_hours * 60 + exercise_minutes
    active_minutes = min(active_minutes, 1440)

    # Sedentary minutes
    sedentary_minutes = 1440 - active_minutes

    # BPM stats
    cursor.execute("""
        SELECT AVG(heart_rate), MAX(heart_rate) FROM heart_rate_original
        WHERE DATE(time_from) = ?
    """, (date,))
    bpm_avg, bpm_max = cursor.fetchone()

    # Simulate standing data
    stand_goal = 12
    stand_achieved = random.randint(6, 14)

    # Insert into daily_activity_fact
    cursor.execute("""
        INSERT INTO daily_activity_fact (
            date, steps, calories, exercise_minutes,
            sedentary_minutes, active_minutes, bpm_avg,
            bpm_max, stand_goal, stand_achieved
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        date, steps, calories, exercise_minutes,
        sedentary_minutes, active_minutes, bpm_avg,
        bpm_max, stand_goal, stand_achieved
    ))

conn.commit()
conn.close()
print("daily_activity_fact inserted using SQL-calculated logic.")
