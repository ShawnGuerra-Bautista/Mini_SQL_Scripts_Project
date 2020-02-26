/*  NOTE: This path refers to the relative path from the Data Directory
    YOUR Data Directory can be found by executing the SHOW DATA_DIRECTORY command in SQL
    Simply copy the MovieLensData into your Data Directory. */

COPY movie FROM 'MovieLensData/movies.dat' (FORMAT TEXT);

COPY actor FROM 'MovieLensData/actors.dat' (FORMAT TEXT);

COPY genre FROM 'MovieLensData/genres.dat' (FORMAT TEXT);

COPY tag_name FROM 'MovieLensData/tag_names.dat' (FORMAT TEXT);

COPY tag FROM 'MovieLensData/tags.dat' (FORMAT TEXT);