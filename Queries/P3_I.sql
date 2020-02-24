SELECT DISTINCT a.name, (max(m.year) - min(m.year)) AS year_interval
FROM actor AS a, movie AS m
WHERE a.mid = m.mid
GROUP BY a.name
ORDER BY year_interval DESC;

-- Without Indexing
-- 95242 rows retrieved starting from 1 in 1 s 614 ms (execution: 994 ms, fetching: 620 ms)
-- 95242 rows retrieved starting from 1 in 1 s 672 ms (execution: 1 s 134 ms, fetching: 538 ms)
-- 95242 rows retrieved starting from 1 in 1 s 641 ms (execution: 1 s 52 ms, fetching: 589 ms)

-- With Indexing
-- 95242 rows retrieved starting from 1 in 1 s 250 ms (execution: 817 ms, fetching: 433 ms)
-- 95242 rows retrieved starting from 1 in 1 s 273 ms (execution: 865 ms, fetching: 408 ms)
-- 95242 rows retrieved starting from 1 in 1 s 227 ms (execution: 834 ms, fetching: 393 ms)