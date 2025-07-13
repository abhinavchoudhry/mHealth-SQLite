CREATE TABLE user_dim (
    user_dim_id     INTEGER PRIMARY KEY AUTOINCREMENT
                            UNIQUE
                            NOT NULL,
    username        TEXT    NOT NULL,
    pwd             TEXT    NOT NULL,
    email           TEXT    NOT NULL,
    first_name      TEXT    NOT NULL,
    last_name       TEXT    NOT NULL,
    dob             TEXT    NOT NULL,
    phone_number    TEXT    NOT NULL,
    sex             TEXT    NOT NULL,
    weight          REAL    NOT NULL,
    weight_unit     TEXT    NOT NULL,
    height          REAL    NOT NULL,
    height_unit     TEXT    NOT NULL,
    age             INTEGER NOT NULL,
    RHR             REAL,
    PHR             TEXT,
    chatbot_summary TEXT,
    user_goal       TEXT
);