-- Note: For composite keys, the index is only created for the composite key, and
-- the order of the composite key matters because the first element will be sorted first
--
-- > Cast Position on the Actor's table is not indexed because it isn't used in any query
-- > Table Tag has an index for the composite (mid, tid) and it's enough given that both usually appear in each query

CREATE INDEX title_index ON movie(title);
CREATE INDEX year_index ON movie(year);
CREATE INDEX rating_index ON movie(rating);
CREATE INDEX num_ratings_index ON movie(num_ratings);

CREATE INDEX name_index ON actor(name);

CREATE INDEX genre_index ON genre(genre);

CREATE INDEX tag_index ON tag_name(tag);