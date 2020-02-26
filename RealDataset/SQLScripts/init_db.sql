/* The project description states that the Movie's year is a DATE,
   but, with the way the data is formatted, it can only be an INTEGER. */

CREATE TABLE transactions(
    date DATE,
    activity CHAR(7),
    source VARCHAR,
    destination VARCHAR,
    energy REAL,
    total_value REAL,
    price REAL,
    PRIMARY KEY (date, activity, source, destination)
);