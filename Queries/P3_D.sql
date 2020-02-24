SELECT m.year, m.title, m.rating
FROM movie AS m
ORDER BY m.year asc, m.rating desc;

-- Without Indexing
-- 10197 rows retrieved starting from 1 in 181 ms (execution: 45 ms, fetching: 136 ms)
-- 10197 rows retrieved starting from 1 in 198 ms (execution: 47 ms, fetching: 151 ms)
-- 10197 rows retrieved starting from 1 in 195 ms (execution: 57 ms, fetching: 138 ms)

-- With Indexing
-- 10197 rows retrieved starting from 1 in 137 ms (execution: 37 ms, fetching: 100 ms)
-- 10197 rows retrieved starting from 1 in 131 ms (execution: 28 ms, fetching: 103 ms)
-- 10197 rows retrieved starting from 1 in 137 ms (execution: 32 ms, fetching: 105 ms)