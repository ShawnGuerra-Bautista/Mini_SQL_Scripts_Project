CREATE TABLE Movie(
    mid INTEGER,
    title VARCHAR UNIQUE,
    year DATE UNIQUE,
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

