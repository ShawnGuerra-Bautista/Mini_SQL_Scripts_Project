SELECT a.name
FROM movie AS m, actor AS a
WHERE m.mid = a.mid AND m.title = 'The Dark Knight'
ORDER BY m.title ASC;

-- Without Indexing
-- 91 rows retrieved starting from 1 in 51 ms (execution: 11 ms, fetching: 40 ms)
-- 91 rows retrieved starting from 1 in 47 ms (execution: 7 ms, fetching: 40 ms)
-- 91 rows retrieved starting from 1 in 33 ms (execution: 7 ms, fetching: 26 ms)

-- With Indexing
-- 91 rows retrieved starting from 1 in 49 ms (execution: 9 ms, fetching: 40 ms)
-- 91 rows retrieved starting from 1 in 42 ms (execution: 8 ms, fetching: 34 ms)
-- 91 rows retrieved starting from 1 in 52 ms (execution: 13 ms, fetching: 39 ms)