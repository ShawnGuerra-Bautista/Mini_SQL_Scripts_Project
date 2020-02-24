SELECT g.genre, COUNT(*)
FROM movie AS m, genre AS g
WHERE m.mid = g.mid
GROUP BY g.genre
HAVING COUNT(*) > 1000
ORDER BY g.genre ASC;

-- Without Indexing
-- 7 rows retrieved starting from 1 in 49 ms (execution: 20 ms, fetching: 29 ms)
-- 7 rows retrieved starting from 1 in 47 ms (execution: 22 ms, fetching: 25 ms)
-- 7 rows retrieved starting from 1 in 40 ms (execution: 18 ms, fetching: 22 ms)

-- With Indexing
-- 7 rows retrieved starting from 1 in 50 ms (execution: 21 ms, fetching: 29 ms)
-- 7 rows retrieved starting from 1 in 42 ms (execution: 23 ms, fetching: 19 ms)
-- 7 rows retrieved starting from 1 in 46 ms (execution: 20 ms, fetching: 26 ms)