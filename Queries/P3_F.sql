-- 1
SELECT *
FROM movie AS m1
WHERE m1.num_ratings >= (
    SELECT max(m2.num_ratings)
    FROM movie AS m2);

-- Without Indexing
-- 2 rows retrieved starting from 1 in 48 ms (execution: 7 ms, fetching: 41 ms)
-- 2 rows retrieved starting from 1 in 32 ms (execution: 9 ms, fetching: 23 ms)
-- 2 rows retrieved starting from 1 in 31 ms (execution: 11 ms, fetching: 20 ms)

-- With Indexing
-- 2 rows retrieved starting from 1 in 37 ms (execution: 5 ms, fetching: 32 ms)
-- 2 rows retrieved starting from 1 in 28 ms (execution: 5 ms, fetching: 23 ms)
-- 2 rows retrieved starting from 1 in 30 ms (execution: 6 ms, fetching: 24 ms)

-- 2
SELECT *
FROM movie AS m1
WHERE m1.rating >= (
    SELECT max(m2.rating)
    FROM movie AS m2)
ORDER BY m1.mid;

-- Without Indexing
-- 1 row retrieved starting from 1 in 51 ms (execution: 10 ms, fetching: 41 ms)
-- 1 row retrieved starting from 1 in 34 ms (execution: 9 ms, fetching: 25 ms)
-- 1 row retrieved starting from 1 in 32 ms (execution: 9 ms, fetching: 23 ms)

-- With Indexing
-- 1 row retrieved starting from 1 in 43 ms (execution: 9 ms, fetching: 34 ms)
-- 1 row retrieved starting from 1 in 33 ms (execution: 8 ms, fetching: 25 ms)
-- 1 row retrieved starting from 1 in 37 ms (execution: 8 ms, fetching: 29 ms)

-- 3
((SELECT *
FROM movie AS m1
WHERE m1.num_ratings >= (
    SELECT max(m2.num_ratings)
    FROM movie AS m2))
INTERSECT
(SELECT *
FROM movie AS m1
WHERE m1.rating >= (
    SELECT max(m2.rating)
    FROM movie AS m2)
ORDER BY m1.mid));

-- Without Indexing
-- 0 rows retrieved in 51 ms (execution: 22 ms, fetching: 29 ms)
-- 0 rows retrieved in 36 ms (execution: 14 ms, fetching: 22 ms)
-- 0 rows retrieved in 59 ms (execution: 35 ms, fetching: 24 ms)

-- With Indexing
-- 0 rows retrieved in 38 ms (execution: 6 ms, fetching: 32 ms)
-- 0 rows retrieved in 37 ms (execution: 9 ms, fetching: 28 ms)
-- 0 rows retrieved in 37 ms (execution: 13 ms, fetching: 24 ms)

-- 4
SELECT *
FROM movie AS m1
WHERE m1.rating <= (
    SELECT min(m2.rating)
    FROM movie AS m2)
ORDER BY m1.mid;

-- Without Indexing
-- 2622 rows retrieved starting from 1 in 92 ms (execution: 25 ms, fetching: 67 ms)
-- 2622 rows retrieved starting from 1 in 82 ms (execution: 17 ms, fetching: 65 ms)
-- 2622 rows retrieved starting from 1 in 100 ms (execution: 17 ms, fetching: 83 ms)

-- With Indexing
-- 2622 rows retrieved starting from 1 in 69 ms (execution: 13 ms, fetching: 56 ms)
-- 2622 rows retrieved starting from 1 in 68 ms (execution: 24 ms, fetching: 44 ms)
-- 2622 rows retrieved starting from 1 in 62 ms (execution: 14 ms, fetching: 48 ms)

-- 5
((SELECT *
FROM movie AS m1
WHERE m1.num_ratings >= (
    SELECT max(m2.num_ratings)
    FROM movie AS m2))
INTERSECT
(SELECT *
FROM movie AS m1
WHERE m1.rating <= (
    SELECT min(m2.rating)
    FROM movie AS m2)
ORDER BY m1.mid));

-- Without Indexing
-- 0 rows retrieved in 55 ms (execution: 22 ms, fetching: 33 ms)
-- 0 rows retrieved in 51 ms (execution: 18 ms, fetching: 33 ms)
-- 0 rows retrieved in 47 ms (execution: 15 ms, fetching: 32 ms)

-- With Indexing
-- 0 rows retrieved in 44 ms (execution: 19 ms, fetching: 25 ms)
-- 0 rows retrieved in 33 ms (execution: 7 ms, fetching: 26 ms)
-- 0 rows retrieved in 38 ms (execution: 9 ms, fetching: 29 ms)

-- 6
-- TODO: Put the answers into the report.
-- The hypothesis/conjecture for problems f3 and f5 are false. Querying for the intersect between
-- the movies with the highest number of rating and movies with the highest rating result in an empty set.
-- Also, querying for the intersect between the movies with the highest number of rating and lowest rating result
-- in an empty set too.
-- This is also proven by the fact that, for each case, when we evaluate the two queries individually there are no
-- overlapping rows.