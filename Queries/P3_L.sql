-- Normalization = (x_i - x_min)/(x_max - x_min)
-- In this case, it's (|x_1 - x_2| - 0)/(5 - 0)

-- View Helpers to computer numbers

CREATE VIEW num_movie_actor AS
    (SELECT m.mid, COUNT(DISTINCT a.name) AS num_actor
    FROM movie AS m, actor AS a
    WHERE m.mid = a.mid
    GROUP BY m.mid);

CREATE VIEW num_movie_common_actor AS
    (SELECT m1.mid, COUNT(DISTINCT a1.name) AS num_com_actor
    FROM movie AS m1, actor AS a1, actor AS a2, movie AS m2
    WHERE m1.mid = a1.mid AND a1.name = a2.name AND a2.mid = m2.mid AND m2.title = 'Mr. & Mrs. Smith'
    GROUP BY m1.mid);

CREATE VIEW num_movie_tag AS
    (SELECT DISTINCT m.mid, COUNT(DISTINCT tt.tag) AS num_tag
    FROM movie AS m, tag AS t, tag_name as tt
    WHERE m.mid = t.mid AND t.tid = tt.tid
    GROUP BY m.mid);

CREATE VIEW num_movie_common_tag AS
    (SELECT m1.mid, COUNT(DISTINCT tt1.tag) AS num_com_tag
    FROM movie AS m1, tag AS t1, tag_name as tt1, movie AS m2, tag AS t2, tag_name as tt2
    WHERE m1.mid = t1.mid AND t1.tid = tt1.tid
      AND tt1.tag = tt2.tag AND tt2.tid = t2.tid
      AND t2.mid = m2.mid AND m2.title = 'Mr. & Mrs. Smith'
    GROUP BY m1.mid);

CREATE VIEW num_movie_genre AS
    (SELECT DISTINCT m.mid, COUNT(DISTINCT g.genre) AS num_genre
    FROM movie AS m, genre AS g
    WHERE m.mid = g.mid
    GROUP BY m.mid);

CREATE VIEW num_movie_common_genre AS
    (SELECT m1.mid, COUNT(DISTINCT g1.genre) AS num_com_genre
    FROM movie AS m1, genre AS g1, genre AS g2, movie AS m2
    WHERE m1.mid = g1.mid AND g1.genre = g2.genre AND g2.mid = m2.mid AND m2.title = 'Mr. & Mrs. Smith'
    GROUP BY m1.mid);

-- Views for the fractions/gaps

CREATE VIEW fraction_actor AS
    (SELECT nma.mid, ((COALESCE(nmca.num_com_actor, 0.0))/nma.num_actor) AS fraction_actor
    FROM num_movie_actor AS nma LEFT OUTER JOIN num_movie_common_actor AS nmca on nma.mid = nmca.mid
    ORDER BY fraction_actor DESC);

CREATE VIEW fraction_tag AS
    (SELECT nmt.mid, ((COALESCE(nmct.num_com_tag, 0.0))/nmt.num_tag) AS fraction_actor
    FROM num_movie_tag AS nmt LEFT OUTER JOIN num_movie_common_tag AS nmct on nmt.mid = nmct.mid
    ORDER BY fraction_actor DESC);

CREATE VIEW fraction_genre AS
    (SELECT nmg.mid, ((COALESCE(nmcg.num_com_genre, 0.0))/nmg.num_genre) AS fraction_genre
    FROM num_movie_genre AS nmg LEFT OUTER JOIN num_movie_common_genre AS nmcg on nmg.mid = nmcg.mid
    ORDER BY fraction_genre DESC);

CREATE VIEW age_gap AS
    (SELECT DISTINCT m2.mid, @(m1.year - m2.year) AS year_gap,
                     (@(m1.year - COALESCE(m2.year, 0.0))/(SELECT MAX(m.year) FROM movie AS m)) AS normalized_year_gap
    FROM movie AS m1, movie AS m2
    WHERE m1.title = 'Mr. & Mrs. Smith'
    ORDER BY normalized_year_gap DESC);

CREATE VIEW rating_gap AS
    (SELECT DISTINCT m2.mid, @(m1.rating - COALESCE(m2.rating, 0.0)) AS rate_gap,
                     (@(m1.rating - COALESCE(m2.rating, 0.0))/5.0) AS normalized_rate_gap
    FROM movie AS m1, movie AS m2
    WHERE m1.title = 'Mr. & Mrs. Smith'
    ORDER BY normalized_rate_gap DESC);

-- Actual query for getting the recommended movies

SELECT DISTINCT m.title, m.rating,
                (((fa.fraction_actor + fg.fraction_genre + ft.fraction_actor
                      + (1 - ag.normalized_year_gap) + (1 - rg.normalized_rate_gap))/5)*100) AS percentage
FROM movie as m, fraction_actor AS fa, fraction_genre AS fg, fraction_tag AS ft, age_gap AS ag, rating_gap AS rg
WHERE m.mid = fa.mid AND fa.mid = fa.mid AND fa.mid = fg.mid
  AND fg.mid = ft.mid AND ft.mid = ag.mid AND ag.mid = rg.mid
  AND m.title <> 'Mr. & Mrs. Smith'
ORDER BY percentage DESC;