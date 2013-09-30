CREATE TABLE todos (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        name       TEXT ,
        comment    TEXT ,
        created_at      TIMESTAMP default current_timestamp,
        updated_at      TIMESTAMP default current_timestamp,
        deadline        DATETIME
);

INSERT INTO todos (name, comment) values ("testName", "testComment");