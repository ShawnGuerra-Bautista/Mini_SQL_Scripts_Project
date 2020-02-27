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
ORDER BY m1.mid ASC;

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
    FROM movie AS m2))
ORDER BY mid ASC);

-- 4
SELECT *
FROM movie AS m1
WHERE m1.rating <= (
    SELECT min(m2.rating)
    FROM movie AS m2)
ORDER BY m1.mid ASC;

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
    FROM movie AS m2))
ORDER BY mid ASC);
