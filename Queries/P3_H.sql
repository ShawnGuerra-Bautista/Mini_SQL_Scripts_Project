-- 1
CREATE VIEW high_ratings AS
    (SELECT DISTINCT a.name
    FROM actor AS a, movie AS m
    WHERE a.mid = m.mid AND m.rating >= 4.0);

CREATE VIEW low_ratings AS
    (SELECT DISTINCT a.name
    FROM actor AS a, movie AS m
    WHERE a.mid = m.mid AND m.rating <= 4.0);

-- 2
SELECT COUNT(*)
FROM ((SELECT * FROM high_ratings) EXCEPT (SELECT * FROM low_ratings)) AS no_flop_actors;

-- Without Indexing
-- 1 row retrieved starting from 1 in 222 ms (execution: 206 ms, fetching: 16 ms)
-- 1 row retrieved starting from 1 in 227 ms (execution: 212 ms, fetching: 15 ms)
-- 1 row retrieved starting from 1 in 219 ms (execution: 202 ms, fetching: 17 ms)

-- With Indexing
-- 1 row retrieved starting from 1 in 214 ms (execution: 192 ms, fetching: 22 ms)
-- 1 row retrieved starting from 1 in 217 ms (execution: 200 ms, fetching: 17 ms)
-- 1 row retrieved starting from 1 in 208 ms (execution: 187 ms, fetching: 21 ms)

-- 3
SELECT no_flop_actors.name, COUNT(*) AS acting_times
FROM ((SELECT * FROM high_ratings) EXCEPT (SELECT * FROM low_ratings)) AS no_flop_actors, actor AS a, movie AS m
WHERE no_flop_actors.name = a.name AND a.mid = m.mid
GROUP BY no_flop_actors.name
ORDER BY acting_times DESC, no_flop_actors.name ASC
LIMIT 10;

-- Without Indexing
-- 10 rows retrieved starting from 1 in 283 ms (execution: 247 ms, fetching: 36 ms)
-- 10 rows retrieved starting from 1 in 302 ms (execution: 273 ms, fetching: 29 ms)
-- 10 rows retrieved starting from 1 in 255 ms (execution: 240 ms, fetching: 15 ms)

-- With Indexing
-- 10 rows retrieved starting from 1 in 246 ms (execution: 232 ms, fetching: 14 ms)
-- 10 rows retrieved starting from 1 in 254 ms (execution: 237 ms, fetching: 17 ms)
-- 10 rows retrieved starting from 1 in 245 ms (execution: 227 ms, fetching: 18 ms)