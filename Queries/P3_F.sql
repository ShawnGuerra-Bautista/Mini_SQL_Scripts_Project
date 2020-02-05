-- 1
SELECT *
FROM movie AS m1
WHERE m1.num_ratings >= (
    SELECT max(m2.num_ratings)
    FROM movie AS m2);

-- 2
SELECT *
FROM movie AS m1
WHERE m1.rating >= (
    SELECT max(m2.rating)
    FROM movie AS m2)
ORDER BY m1.mid;

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

-- 4
SELECT *
FROM movie AS m1
WHERE m1.rating <= (
    SELECT min(m2.rating)
    FROM movie AS m2)
ORDER BY m1.mid;

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

-- 6
-- TODO: Put the answers into the report.
-- The hypothesis/conjecture for problems f3 and f5 are false. Querying for the intersect between
-- the movies with the highest number of rating and movies with the highest rating result in an empty set.
-- Also, querying for the intersect between the movies with the highest number of rating and lowest rating result
-- in an empty set too.
-- This is also proven by the fact that, for each case, when we evaluate the two queries individually there are no
-- overlapping rows.