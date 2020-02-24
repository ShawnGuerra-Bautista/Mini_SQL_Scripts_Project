SELECT m.title
FROM movie AS m, actor AS a
WHERE m.mid = a.mid AND a.name = 'Daniel Craig'
ORDER BY m.title ASC;

-- Without Indexing
-- 21 rows retrieved starting from 1 in 70 ms (execution: 44 ms, fetching: 26 ms)
-- 21 rows retrieved starting from 1 in 69 ms (execution: 39 ms, fetching: 30 ms)
-- 21 rows retrieved starting from 1 in 47 ms (execution: 23 ms, fetching: 24 ms)

-- With Indexing
-- 21 rows retrieved starting from 1 in 48 ms (execution: 15 ms, fetching: 33 ms)
-- 21 rows retrieved starting from 1 in 56 ms (execution: 12 ms, fetching: 44 ms)
-- 21 rows retrieved starting from 1 in 57 ms (execution: 9 ms, fetching: 48 ms)