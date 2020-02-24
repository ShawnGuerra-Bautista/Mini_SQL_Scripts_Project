-- View Helpers to computer numbers

CREATE MATERIALIZED VIEW num_movie_actor AS
    (SELECT m.mid, COUNT(DISTINCT a.name) AS num_actor
    FROM movie AS m, actor AS a
    WHERE m.mid = a.mid
    GROUP BY m.mid);

CREATE UNIQUE INDEX num_movie_actor_mid_index ON num_movie_actor(mid);
CREATE INDEX num_actor_index ON num_movie_actor(num_actor);

CREATE MATERIALIZED VIEW num_movie_common_actor AS
    (SELECT m1.mid, COUNT(DISTINCT a1.name) AS num_com_actor
    FROM movie AS m1, actor AS a1, actor AS a2, movie AS m2
    WHERE m1.mid = a1.mid AND a1.name = a2.name AND a2.mid = m2.mid AND m2.title = 'Mr. & Mrs. Smith'
    GROUP BY m1.mid);

CREATE UNIQUE INDEX num_movie_com_actor_mid_index ON num_movie_common_actor(mid);
CREATE INDEX num_com_actor_index ON num_movie_common_actor(num_com_actor);

CREATE MATERIALIZED VIEW num_movie_tag AS
    (SELECT DISTINCT m.mid, COUNT(DISTINCT tt.tag) AS num_tag
    FROM movie AS m, tag AS t, tag_name as tt
    WHERE m.mid = t.mid AND t.tid = tt.tid
    GROUP BY m.mid);

CREATE UNIQUE INDEX num_movie_tag_mid_index ON num_movie_tag(mid);
CREATE INDEX num_tag_index ON num_movie_tag(num_tag);

CREATE MATERIALIZED VIEW num_movie_common_tag AS
    (SELECT m1.mid, COUNT(DISTINCT tt1.tag) AS num_com_tag
    FROM movie AS m1, tag AS t1, tag_name as tt1, movie AS m2, tag AS t2, tag_name as tt2
    WHERE m1.mid = t1.mid AND t1.tid = tt1.tid
      AND tt1.tag = tt2.tag AND tt2.tid = t2.tid
      AND t2.mid = m2.mid AND m2.title = 'Mr. & Mrs. Smith'
    GROUP BY m1.mid);

CREATE UNIQUE INDEX num_movie_com_tag_mid_index ON num_movie_common_tag(mid);
CREATE INDEX num_com_tag_index ON num_movie_common_tag(num_com_tag);

CREATE MATERIALIZED VIEW num_movie_genre AS
    (SELECT DISTINCT m.mid, COUNT(DISTINCT g.genre) AS num_genre
    FROM movie AS m, genre AS g
    WHERE m.mid = g.mid
    GROUP BY m.mid);

CREATE UNIQUE INDEX num_movie_genre_mid_index ON num_movie_genre(mid);
CREATE INDEX num_genre_index ON num_movie_genre(num_genre);

CREATE MATERIALIZED VIEW num_movie_common_genre AS
    (SELECT m1.mid, COUNT(DISTINCT g1.genre) AS num_com_genre
    FROM movie AS m1, genre AS g1, genre AS g2, movie AS m2
    WHERE m1.mid = g1.mid AND g1.genre = g2.genre AND g2.mid = m2.mid AND m2.title = 'Mr. & Mrs. Smith'
    GROUP BY m1.mid);

CREATE UNIQUE INDEX num_movie_com_genre_mid_index ON num_movie_common_genre(mid);
CREATE INDEX num_com_genre_index ON num_movie_common_genre(num_com_genre);

-- Views for the fractions/gaps

CREATE MATERIALIZED VIEW fraction_actor AS
    (SELECT nma.mid, ((COALESCE(nmca.num_com_actor, 0.0))/nma.num_actor) AS fraction_actor
    FROM num_movie_actor AS nma LEFT OUTER JOIN num_movie_common_actor AS nmca on nma.mid = nmca.mid
    ORDER BY fraction_actor DESC);

CREATE UNIQUE INDEX fraction_actor_mid_index ON fraction_actor(mid);
CREATE INDEX fraction_actor_index ON fraction_actor(fraction_actor);

CREATE MATERIALIZED VIEW fraction_tag AS
    (SELECT nmt.mid, ((COALESCE(nmct.num_com_tag, 0.0))/nmt.num_tag) AS fraction_tag
    FROM num_movie_tag AS nmt LEFT OUTER JOIN num_movie_common_tag AS nmct on nmt.mid = nmct.mid
    ORDER BY fraction_tag DESC);

CREATE UNIQUE INDEX fraction_tag_mid_index ON fraction_tag(mid);
CREATE INDEX fraction_tag_index ON fraction_tag(fraction_tag);

CREATE MATERIALIZED VIEW fraction_genre AS
    (SELECT nmg.mid, ((COALESCE(nmcg.num_com_genre, 0.0))/nmg.num_genre) AS fraction_genre
    FROM num_movie_genre AS nmg LEFT OUTER JOIN num_movie_common_genre AS nmcg on nmg.mid = nmcg.mid
    ORDER BY fraction_genre DESC);

CREATE UNIQUE INDEX fraction_genre_mid_index ON fraction_genre(mid);
CREATE INDEX fraction_genre_index ON fraction_genre(fraction_genre);


CREATE MATERIALIZED VIEW age_gap AS
    (SELECT DISTINCT m2.mid, @(m1.year - m2.year) AS year_gap,
                     (@(m1.year - COALESCE(m2.year, 0.0))/(SELECT MAX(m.year) FROM movie AS m)) AS normalized_year_gap
    FROM movie AS m1, movie AS m2
    WHERE m1.title = 'Mr. & Mrs. Smith'
    ORDER BY normalized_year_gap DESC);

CREATE UNIQUE INDEX age_gap_mid_index ON age_gap(mid);
CREATE INDEX year_gap_index ON age_gap(year_gap);
CREATE INDEX normalized_year_gap_index ON age_gap(normalized_year_gap);

CREATE MATERIALIZED VIEW rating_gap AS
    (SELECT DISTINCT m2.mid, @(m1.rating - COALESCE(m2.rating, 0.0)) AS rate_gap,
                     (@(m1.rating - COALESCE(m2.rating, 0.0))/5.0) AS normalized_rate_gap
    FROM movie AS m1, movie AS m2
    WHERE m1.title = 'Mr. & Mrs. Smith'
    ORDER BY normalized_rate_gap DESC);

CREATE UNIQUE INDEX rating_gap_mid_index ON rating_gap(mid);
CREATE INDEX rate_gap_index ON rating_gap(rate_gap);
CREATE INDEX normalized_rate_gap_index ON rating_gap(normalized_rate_gap);

-- Actual query for getting the recommended movies

SELECT DISTINCT m.title, m.rating,
                (((fa.fraction_actor + fg.fraction_genre + ft.fraction_tag
                      + (1 - ag.normalized_year_gap) + (1 - rg.normalized_rate_gap))/5)*100) AS percentage
FROM movie as m, fraction_actor AS fa, fraction_genre AS fg, fraction_tag AS ft, age_gap AS ag, rating_gap AS rg
WHERE m.mid = fa.mid AND fa.mid = fa.mid AND fa.mid = fg.mid
  AND fg.mid = ft.mid AND ft.mid = ag.mid AND ag.mid = rg.mid
  AND m.title <> 'Mr. & Mrs. Smith'
ORDER BY percentage DESC
LIMIT 10;