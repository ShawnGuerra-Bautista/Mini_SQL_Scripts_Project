CREATE VIEW co_actors_number AS
    (SELECT a1.name, COUNT(DISTINCT a2.name) as num_actor
    FROM actor AS a1, movie AS m1, actor AS a2
    WHERE a1.mid = m1.mid AND m1.mid = a2.mid AND a1.name <> a2.name
    GROUP BY a1.name);

SELECT cn1.name, cn1.num_actor
FROM co_actors_number as cn1
WHERE cn1.num_actor >= (SELECT MAX(cn2.num_actor) FROM co_actors_number as cn2)
ORDER BY cn1.name ASC;

-- Without Indexing
-- 1 row retrieved starting from 1 in 38 s 588 ms (execution: 38 s 562 ms, fetching: 26 ms)
-- 1 row retrieved starting from 1 in 39 s 605 ms (execution: 39 s 588 ms, fetching: 17 ms)
-- 1 row retrieved starting from 1 in 38 s 230 ms (execution: 38 s 212 ms, fetching: 18 ms)

-- With Indexing
-- 1 row retrieved starting from 1 in 16 s 756 ms (execution: 16 s 739 ms, fetching: 17 ms)
-- 1 row retrieved starting from 1 in 16 s 611 ms (execution: 16 s 595 ms, fetching: 16 ms)
-- 1 row retrieved starting from 1 in 16 s 508 ms (execution: 16 s 492 ms, fetching: 16 ms)