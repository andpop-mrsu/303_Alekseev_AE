CREATE TABLE students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name CHARACTER(20),
    surname CHARACTER(30),
    age INTEGER,
    gender CHARACTER(1)
);

INSERT INTO students (name, surname, age, gender) VALUES ('Ваня', 'Петров', 20, 'М');
