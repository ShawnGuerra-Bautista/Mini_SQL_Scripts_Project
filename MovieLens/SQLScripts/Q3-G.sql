((SELECT m.year, m.title, m.rating
FROM movie AS m
WHERE (m.year >= 2005 AND m.year <= 2011
           AND m.rating = (
               SELECT max(mhr.rating)
               FROM movie mhr
               WHERE mhr.year = m.year
               GROUP BY mhr.year)))
UNION
(SELECT m.year, m.title, m.rating
FROM movie AS m
WHERE (m.year >= 2005 AND m.year <= 2011
           AND m.rating = (
               SELECT min(mlr.rating)
               FROM movie mlr
               WHERE mlr.year = m.year
               GROUP BY mlr.year))))
ORDER BY year ASC, rating ASC, title ASC;
