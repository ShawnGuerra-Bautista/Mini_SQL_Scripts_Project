/* The project description states that the Movie's year is a DATE,
   but, with the way the data is formatted, it can only be an INTEGER. */

CREATE TABLE Movie(
    mid INTEGER,
    title VARCHAR,
    year INTEGER,
    rating REAL,
    num_ratings INTEGER,
    PRIMARY KEY (mid)
);

CREATE TABLE Actor(
    mid INTEGER,
    name VARCHAR,
    cast_position INTEGER,
    PRIMARY KEY (mid, name),
    FOREIGN KEY (mid) REFERENCES Movie
);

CREATE TABLE Genre(
    mid INTEGER,
    genre VARCHAR,
    PRIMARY KEY (mid, genre),
    FOREIGN KEY (mid) REFERENCES Movie
);

CREATE TABLE Tag_Name(
    tid INTEGER,
    tag VARCHAR,
    PRIMARY KEY (tid)
);

CREATE TABLE Tag(
    mid INTEGER,
    tid INTEGER,
    PRIMARY KEY (mid, tid),
    FOREIGN KEY (mid) REFERENCES Movie,
    FOREIGN KEY (tid) REFERENCES Tag_Name
);

