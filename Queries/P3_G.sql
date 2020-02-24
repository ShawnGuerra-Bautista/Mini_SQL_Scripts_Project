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

-- Without Indexing
-- 168 rows retrieved starting from 1 in 2 s 704 ms (execution: 2 s 675 ms, fetching: 29 ms)
-- 168 rows retrieved starting from 1 in 2 s 803 ms (execution: 2 s 780 ms, fetching: 23 ms)
-- 168 rows retrieved starting from 1 in 2 s 781 ms (execution: 2 s 761 ms, fetching: 20 ms)

-- With Indexing
-- 168 rows retrieved starting from 1 in 427 ms (execution: 410 ms, fetching: 17 ms)
-- 168 rows retrieved starting from 1 in 346 ms (execution: 319 ms, fetching: 27 ms)
-- 168 rows retrieved starting from 1 in 363 ms (execution: 338 ms, fetching: 25 ms)
